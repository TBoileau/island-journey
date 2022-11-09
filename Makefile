DISABLE_XDEBUG=XDEBUG_MODE=off

env ?= dev
db-driver ?= mysql
db-user ?= root
db-password ?= password
db-host ?= 127.0.0.1
db-port ?= 3306
db-name ?= island_journey
db-version ?= 8.0
db-charset ?= utf8mb4

sf-start: ## Démarrer le serveur Symfony
	symfony server:start
.PHONY: sf-start

sf-stop: ## Stopper le serveur Symfony
	symfony server:stop
.PHONY: sf-start

sf-cc: ## Vider le cache Symfony
	$(DISABLE_XDEBUG) symfony console cache:clear
.PHONY: sf-cc

composer: ## Installation des dépendances de composer.json
	composer install
.PHONY: composer

composer-update: ## Installation des dépendances de composer.json
	composer update
.PHONY: composer

yarn: ## Installation des dépendances de package.json
	yarn install
.PHONY: yarn

yarn-watch: ## Compilation des assets en mode dev
	yarn run watch
.PHONY: yarn-watch

yarn-dev: ## Build des assets pour l'environnement de développement
	yarn run dev
.PHONY: yarn-dev

yarn-build: ## Build des assets pour l'environnement de production
	yarn run build
.PHONY: yarn-build

install: ## Installation du projet
	make composer
	make yarn
	make prepare env=dev db-user=$(db-user) db-password=$(db-password) db-name=$(db-name) db-host=$(db-host) db-port=$(db-port) db-version=$(db-version) db-charset=$(db-charset)
	make yarn-dev
.PHONY: install

prepare: ## Préparation du projet
	cp .env.dist .env.$(env).local
	sed -i -e 's/db-driver/$(db-driver)/' .env.$(env).local
	sed -i -e 's/db-user/$(db-user)/' .env.$(env).local
	sed -i -e 's/db-password/$(db-password)/' .env.$(env).local
	sed -i -e 's/db-name/$(db-name)/' .env.$(env).local
	sed -i -e 's/db-host/$(db-host)/' .env.$(env).local
	sed -i -e 's/db-port/$(db-port)/' .env.$(env).local
	sed -i -e 's/db-version/$(db-version)/' .env.$(env).local
	sed -i -e 's/db-charset/$(db-charset)/' .env.$(env).local
	sed -i -e 's/env/$(env)/' .env.$(env).local
	make db env=$(env)
.PHONY: prepare

db-schema: ## Création du schéma de la base de données
	$(DISABLE_XDEBUG) php bin/console doctrine:database:drop --if-exists --force --env=$(env)
	$(DISABLE_XDEBUG) php bin/console doctrine:database:create --env=$(env)
	$(DISABLE_XDEBUG) php bin/console doctrine:migration:migrate --no-interaction --allow-no-migration --env=$(env)
.PHONY: db-schema

db-migration: ## Création d'une migration
	$(DISABLE_XDEBUG) php bin/console make:migration
.PHONY: db-migration

db: ## Création du schéma de la base de données et chargement des fixtures
	make db-schema env=$(env)
.PHONY: db

help: ## Show this help.
	@echo "Symfony-And-Docker-Makefile"
	@echo "---------------------------"
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help