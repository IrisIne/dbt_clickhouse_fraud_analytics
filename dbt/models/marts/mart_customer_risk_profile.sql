{{ config(engine='MergeTree()', order_by='customer_id') }}

WITH customer_metrics AS (
    SELECT
        customer_id,
        any(name_1) AS name_1,
        any(name_2) AS name_2,
        any(customer_name) AS customer_name,
        any(us_state) AS us_state,
        count() AS transaction_count,
        countIf(fraud_flag = 1) AS fraud_count,
        round(100.0 * countIf(fraud_flag = 1) / count(), 2) AS fraud_rate,
        round(avg(amount), 2) AS average_amount,
        round(max(amount), 2) AS maximum_amount,
        round(sum(amount), 2) AS total_amount,
        min(transaction_time) AS first_transaction_time,
        max(transaction_time) AS last_transaction_time
    FROM {{ ref('stg_transactions') }}
    GROUP BY customer_id
)

SELECT
    *,
    {{ customer_risk_level('fraud_rate', 'fraud_count', 'average_amount') }} AS risk_level
FROM customer_metrics
