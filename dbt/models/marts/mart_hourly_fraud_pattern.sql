{{ config(engine='MergeTree()', order_by='(day_of_week_number, transaction_hour)') }}

SELECT
    day_of_week_number,
    any(day_of_week_name) AS day_of_week_name,
    transaction_hour,
    count() AS transaction_count,
    countIf(fraud_flag = 1) AS fraud_count,
    round(100.0 * countIf(fraud_flag = 1) / count(), 2) AS fraud_rate,
    round(avg(amount), 2) AS average_amount,
    round(sum(amount), 2) AS total_amount
FROM {{ ref('stg_transactions') }}
GROUP BY day_of_week_number, transaction_hour
