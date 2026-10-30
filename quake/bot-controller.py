"""Keep five total players when humans are present and no bots when empty."""

import http.cookiejar
import json
import os
import time
import urllib.error
import urllib.request


API_URL = os.environ.get("QUAKE_API_URL", "http://quake/admin/api").rstrip("/")
MIN_PLAYERS = int(os.environ.get("BOT_MIN_PLAYERS", "5"))
POLL_SECONDS = max(3, int(os.environ.get("POLL_SECONDS", "5")))


class ApiError(RuntimeError):
    def __init__(self, status, message):
        super().__init__(message)
        self.status = status


class QuakeApi:
    def __init__(self, password):
        self.password = password
        self.cookies = http.cookiejar.CookieJar()
        self.http = urllib.request.build_opener(
            urllib.request.HTTPCookieProcessor(self.cookies)
        )

    def _request(self, method, path, body=None):
        data = None if body is None else json.dumps(body).encode("utf-8")
        headers = {} if data is None else {"Content-Type": "application/json"}
        request = urllib.request.Request(
            API_URL + path, data=data, headers=headers, method=method
        )
        try:
            with self.http.open(request, timeout=10) as response:
                result = json.loads(response.read())
        except urllib.error.HTTPError as error:
            message = "API returned HTTP %d" % error.code
            try:
                payload = json.loads(error.read())
                message = payload.get("error", message)
            except (ValueError, OSError):
                pass
            raise ApiError(error.code, message) from error
        if result.get("error"):
            raise ApiError(200, result["error"])
        return result

    def login(self):
        self.cookies.clear()
        self._request("POST", "/login", {"user": "admin", "password": self.password})

    def call(self, method, path, body=None):
        try:
            return self._request(method, path, body)
        except ApiError as error:
            if error.status != 401 or path == "/login":
                raise
            self.login()
            return self._request(method, path, body)


def human_count(players):
    return sum(1 for player in players if not player.get("bot", False))


def set_min_players(api, count):
    api.call("POST", "/settings", {"settings": {"bot_minplayers": count}})


def main():
    password = os.environ.get("ADMIN_PASSWORD", "")
    if not password:
        raise SystemExit("ADMIN_PASSWORD is required in the local quake/.env file.")
    api = QuakeApi(password)
    api.login()

    # Resume from the saved live setting, then reconcile it with the roster.
    settings = api.call("GET", "/settings")["settings"]
    try:
        current_min = int(settings["bot_minplayers"].get("value") or 0)
    except (KeyError, TypeError, ValueError):
        current_min = 0

    print("Controller started; target is %d total players." % MIN_PLAYERS, flush=True)
    while True:
        try:
            players = api.call("GET", "/public").get("players", [])
            humans = human_count(players)
            wanted_min = MIN_PLAYERS if humans else 0

            if wanted_min != current_min:
                set_min_players(api, wanted_min)
                current_min = wanted_min
                print("Human players: %d; bot minimum set to %d." % (humans, wanted_min), flush=True)

            # bot_minplayers=0 prevents new bots, but the game does not remove
            # existing ones at zero. Kick one at a time, checking the roster
            # again on the next pass so a joining human is never kicked.
            if humans == 0:
                bots = [player for player in players if player.get("bot")]
                if bots:
                    bot = max(bots, key=lambda player: player["num"])
                    api.call("POST", "/kick", {"num": bot["num"]})
                    print("Removed an idle bot.", flush=True)

        except (ApiError, OSError, ValueError, KeyError) as error:
            # Do not log request bodies, cookies, or the admin password.
            print("API check failed: %s" % error, flush=True)

        time.sleep(POLL_SECONDS)


if __name__ == "__main__":
    main()
