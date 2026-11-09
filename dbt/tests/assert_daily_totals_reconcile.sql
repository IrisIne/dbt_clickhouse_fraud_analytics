WITH staging_total AS (
    SELECT count() AS transaction_rows
    FROM {{ ref('stg_transactions') }}
),
mart_total AS (
    SELECT sum(transaction_count) AS transaction_rows
    FROM {{ ref('mart_daily_state_metrics') }}
)

SELECT staging_total.transaction_rows AS staging_count, mart_total.transaction_rows AS mart_count
FROM staging_total
    CROSS JOIN mart_total
WHERE staging_total.transaction_rows != mart_total.transaction_rows
