# Atalhos para o ambiente local RouterLink. Rode `make` para ver os comandos.
# Tudo aqui usa só o docker compose deste repo: não depende de onde os outros repos estão clonados.

COMPOSE := docker compose
# Hosts dos containers que viram localhost quando o serviço roda na IDE
HOSTS := mysql|rabbitmq|routerlink-erp|fiscal-gateway|fiscal-adm|api-fiscal|fiscal-notificacoes

.DEFAULT_GOAL := help
.PHONY: help setup up sefaz infra dev env check-s logs ps down reset

help: ## Lista os comandos
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  make %-22s %s\n", $$1, $$2}'

setup: ## 1ª vez: cria o .env e confere o login no GHCR
	@test -f .env || { cp .env.example .env && echo "✔ .env criado a partir do .env.example"; }
	@grep -q '"ghcr.io"' $(HOME)/.docker/config.json 2>/dev/null \
		&& echo "✔ login no GHCR encontrado" \
		|| printf '✖ faça login no GHCR (token com read:packages):\n  echo <TOKEN> | docker login ghcr.io -u <usuario-github> --password-stdin\n'

up: setup ## Baixa as imagens mais novas e sobe o ecossistema
	$(COMPOSE) pull
	$(COMPOSE) up -d --wait

sefaz: setup ## Igual ao up, incluindo os módulos SEFAZ
	$(COMPOSE) --profile sefaz pull
	$(COMPOSE) --profile sefaz up -d --wait

infra: setup ## Sobe só MySQL e RabbitMQ
	$(COMPOSE) up -d --wait mysql rabbitmq

dev: ## Sobe tudo menos o serviço s=<servico> e mostra as variáveis para a IDE
	@$(MAKE) -s check-s s=$(s)
	@$(MAKE) up
	$(COMPOSE) stop $(s)
	@printf "\n✔ $(s) fora do Docker. Rode na IDE com estas variáveis:\n\n"
	@$(MAKE) -s env s=$(s)

env: ## Variáveis para rodar s=<servico> na IDE (hosts trocados por localhost)
	@$(MAKE) -s check-s s=$(s)
	@$(COMPOSE) config $(s) 2>/dev/null \
		| awk '/^  $(s):$$/{f=1;next} f&&/^  [^ ]/{f=0} f' \
		| awk '/^    environment:$$/{e=1;next} e&&/^    [^ ]/{e=0} e' \
		| sed -E 's/^ +//; s/: /=/; s/"//g; s#(^|[=/])($(HOSTS))([:/]|$$)#\1localhost\3#'

check-s:
	@$(COMPOSE) --profile sefaz config --services | grep -qx "$(s)" || { \
		printf '✖ informe um serviço válido com s=<servico>. Disponíveis:\n'; \
		$(COMPOSE) --profile sefaz config --services | sed 's/^/  /'; exit 1; }

logs: ## Logs de um serviço (s=<servico>) ou de todos
	$(COMPOSE) logs -f $(s)

ps: ## Status e healthchecks
	$(COMPOSE) ps

down: ## Para tudo (mantém os dados)
	$(COMPOSE) --profile sefaz down

reset: ## Para tudo e APAGA os volumes (zera banco e filas)
	@printf "Isso apaga os dados locais do MySQL e RabbitMQ. Digite 'sim' para continuar: "; read r; [ "$$r" = sim ]
	$(COMPOSE) --profile sefaz down -v
