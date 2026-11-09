.PHONY: up build deps seed run test docs lint shell down clean

up:
	docker compose up -d --build

build:
	docker compose up --build dbt-build

deps:
	docker compose run --rm dbt deps

seed:
	docker compose run --rm dbt seed --full-refresh

run:
	docker compose run --rm dbt run

test:
	docker compose run --rm dbt test

docs:
	docker compose up -d dbt-docs

lint:
	docker compose run --rm --entrypoint /bin/bash dbt -ec "cd /usr/app && sqlfluff lint dbt/models dbt/tests dbt/macros"

shell:
	docker compose run --rm --entrypoint /bin/bash dbt

down:
	docker compose down

clean:
	docker compose down -v
