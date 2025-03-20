.PHONY: up down logs database
up:
	mkdir -p ./dags ./logs ./plugins
	chown -R 50000:0 ./dags ./logs ./plugins
	docker-compose up -d 
down:
	docker-compose down -v
logs-postgres:
	docker-compose logs -f postgres
logs-scheduler:
	docker-compose logs -f airflow-scheduler
logs-worker:
	docker-compose logs -f airflow-worker
logs-webserver:
	docker-compose logs -f airflow-webserver
database:
	PGPASSWORD=$(POSTGRES_PASSWORD) psql -h postgres -U $(POSTGRES_USER) -d postgres -c "CREATE DATABASE $(AIRFLOW_DB);"
	PGPASSWORD=$(POSTGRES_PASSWORD) psql -h postgres -U $(POSTGRES_USER) -d postgres -c "CREATE USER $(AIRFLOW_USER) WITH ENCRYPTED PASSWORD '$(AIRFLOW_PASSWORD)';"
	PGPASSWORD=$(POSTGRES_PASSWORD) psql -h postgres -U $(POSTGRES_USER) -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE $(AIRFLOW_DB) TO $(AIRFLOW_USER);"
restart:
	docker-compose restart postgres