{{ config(engine='MergeTree()', order_by='cat_id') }}

SELECT
    cat_id,
    count() AS transaction_count,
    countIf(fraud_flag = 1) AS fraud_count,
    round(100.0 * countIf(fraud_flag = 1) / count(), 2) AS fraud_rate,
    round(sum(amount), 2) AS total_amount,
    round(sumIf(amount, fraud_flag = 1), 2) AS fraud_amount,
    round(avg(amount), 2) AS average_amount
FROM {{ ref('stg_transactions') }}
GROUP BY cat_id
