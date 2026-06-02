docker-compose.yaml:
```
 caddy-gen:
    build:
      context: ./caddy-gen/
```

Dockerfile:
```
# Этап 1: Сборка Caddy с плагином rate_limit
FROM caddy:2.8.4-builder AS caddy-builder

# Устанавливаем плагин rate_limit
# Все плагины должны быть в одной команде xcaddy build
RUN xcaddy build \
    --with github.com/mholt/caddy-ratelimit

# Этап 2: Финальный образ caddy-gen с кастомным Caddy
FROM wemakeservices/caddy-gen:latest

# Копируем собранный бинарник Caddy из этапа сборки
# Перезаписываем стандартный бинарник в образе caddy-gen
COPY --from=caddy-builder /usr/bin/caddy /usr/bin/caddy

# Проверяем, что плагин установлен (опционально, для отладки)
RUN /usr/bin/caddy list-modules | grep ratelimit || true
```

caddy-snippet:
```
(rate_limit_config) {
    rate_limit {
        zone default {
            key {remote_host}
            events 3600
            window 1m
			burst 300
        }
    }
}
```

Add `import rate_limit_config` before tls to template