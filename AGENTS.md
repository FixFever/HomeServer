# Repository guidance

- This is a Windows 10/Docker Desktop homelab repository, not an application with a build/test suite. The root `docker-compose.yml` defines the main stack; `quake/`, `valheim/`, and `torrupd/` have separate Compose projects.
- Compose files are host-specific: they use Windows paths/drives, environment variables, and pre-existing Docker volumes declared `external: true`. Check `docker compose config` (or `docker compose -f <file> config` for a subproject) before applying changes; required host paths, variables, and volumes may not exist on another machine. Never commit credentials.
- Most persistent service configuration/data lives in Docker volumes, not these checked-in files. Avoid renaming/removing volumes or using destructive volume operations without verifying their impact.
- Nextcloud is built from `nextcloud/Dockerfile` (adds `ffmpeg`); after changing its image/build inputs, rebuild with `docker compose build nextcloud` from the repository root.
- `torrupd/TorrUpd.ps1` is a scheduled one-shot job: run it from `C:\git\server\torrupd`; it pulls the image, runs the service once, then runs `docker compose down` for that subproject. Do not confuse it with the root stack.
- `Backup.ps1` and `Restore-DockerVolumes.ps1` are host-specific operational scripts, not tests. Backups pause running containers and synchronize remote folders with `-delete`; restore writes into Docker volumes and changes permissions. Review paths and effects before running either.
- There is no repository test/lint command. For Compose-only changes, validate the affected Compose file with `docker compose config`; no automated tests are defined here.
