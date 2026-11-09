{{ config(engine='MergeTree()', order_by='(transaction_date, us_state)') }}

SELECT
    transaction_date,
    us_state,
    count() AS transaction_count,
    round(sum(amount), 2) AS total_amount,
    round(avg(amount), 2) AS average_amount,
    round(quantileExact(0.95) (amount), 2) AS p95_amount,
    round(100.0 * countIf(is_large_transaction = 1) / count(), 2) AS large_transaction_rate
FROM {{ ref('stg_transactions') }}
GROUP BY transaction_date, us_state
