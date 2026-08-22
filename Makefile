COMPOSE := docker compose --env-file .env -f compose.yaml

.PHONY: config up down logs status test

config:
	$(COMPOSE) config

up: config
	$(COMPOSE) up --detach --build

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs --follow --tail=100

status:
	$(COMPOSE) ps

test:
	./scripts/test-print.sh
