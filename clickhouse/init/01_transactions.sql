CREATE DATABASE IF NOT EXISTS transactions_db;
CREATE DATABASE IF NOT EXISTS analytics;

CREATE TABLE IF NOT EXISTS transactions_db.transactions
(
    transaction_time DateTime CODEC(Delta, ZSTD(1)),
    merch LowCardinality(String),
    cat_id LowCardinality(String),
    amount Decimal(12, 2) CODEC(Delta, ZSTD(1)),
    name_1 LowCardinality(String),
    name_2 LowCardinality(String),
    gender LowCardinality(String),
    street String CODEC(ZSTD(1)),
    one_city LowCardinality(String),
    us_state LowCardinality(String),
    post_code LowCardinality(String),
    lat Float64 CODEC(Gorilla, ZSTD(1)),
    lon Float64 CODEC(Gorilla, ZSTD(1)),
    population_city UInt32 CODEC(Delta, ZSTD(1)),
    jobs LowCardinality(String),
    merchant_lat Float64 CODEC(Gorilla, ZSTD(1)),
    merchant_lon Float64 CODEC(Gorilla, ZSTD(1)),
    target UInt8 CODEC(T64, ZSTD(1))
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(transaction_time)
ORDER BY (us_state, cat_id, transaction_time);

INSERT INTO transactions_db.transactions
SELECT
    parseDateTimeBestEffort(transaction_time),
    merch,
    cat_id,
    amount,
    name_1,
    name_2,
    gender,
    street,
    one_city,
    us_state,
    post_code,
    lat,
    lon,
    population_city,
    jobs,
    merchant_lat,
    merchant_lon,
    target
FROM file(
    'transactions.csv',
    CSVWithNames,
    'transaction_time String, merch String, cat_id String, amount Decimal(12, 2), name_1 String, name_2 String, gender String, street String, one_city String, us_state String, post_code String, lat Float64, lon Float64, population_city UInt32, jobs String, merchant_lat Float64, merchant_lon Float64, target UInt8'
);
