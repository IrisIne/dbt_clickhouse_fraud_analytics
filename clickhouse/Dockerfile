FROM clickhouse/clickhouse-server:24.8-alpine

COPY clickhouse/init/01_transactions.sql /docker-entrypoint-initdb.d/01_transactions.sql
COPY data/transactions.csv /var/lib/clickhouse/user_files/transactions.csv
