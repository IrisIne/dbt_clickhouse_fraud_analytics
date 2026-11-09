{{ config(engine='MergeTree()', order_by='merchant_id') }}

WITH merchant_metrics AS (
    SELECT
        merchant_id,
        any(merch) AS merch,
        any(cat_id) AS primary_category,
        count() AS transaction_count,
        countIf(fraud_flag = 1) AS fraud_count,
        round(100.0 * countIf(fraud_flag = 1) / count(), 2) AS fraud_rate,
        uniqExact(customer_id) AS unique_customers,
        round(sum(amount), 2) AS turnover,
        round(avg(amount), 2) AS average_amount,
        round(max(amount), 2) AS maximum_amount
    FROM {{ ref('stg_transactions') }}
    GROUP BY merchant_id
)

SELECT
    *,
    toUInt8(fraud_rate >= 10 AND transaction_count >= 5) AS suspicious_flag
FROM merchant_metrics
