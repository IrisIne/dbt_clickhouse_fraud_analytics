{{ config(engine='MergeTree()', order_by='us_state') }}

WITH state_metrics AS (
    SELECT
        us_state,
        count() AS transaction_count,
        countIf(fraud_flag = 1) AS fraud_count,
        round(100.0 * countIf(fraud_flag = 1) / count(), 2) AS fraud_rate,
        uniqExact(customer_id) AS unique_customers,
        uniqExact(merchant_id) AS unique_merchants,
        round(sum(amount), 2) AS total_amount,
        round(sumIf(amount, fraud_flag = 1), 2) AS fraud_amount
    FROM {{ ref('stg_transactions') }}
    GROUP BY us_state
)

SELECT
    state_metrics.us_state,
    coalesce(states.state_name, 'Unknown') AS state_name,
    coalesce(states.region, 'Unknown') AS region,
    state_metrics.transaction_count,
    state_metrics.fraud_count,
    state_metrics.fraud_rate,
    state_metrics.unique_customers,
    state_metrics.unique_merchants,
    state_metrics.total_amount,
    state_metrics.fraud_amount
FROM state_metrics
    LEFT JOIN {{ ref('states') }} AS states
        ON state_metrics.us_state = states.state_code
