SELECT 'category' AS mart_name, cat_id AS dimension, fraud_rate
FROM {{ ref('mart_fraud_by_category') }}
WHERE fraud_rate < 0 OR fraud_rate > 100

UNION ALL

SELECT 'state' AS mart_name, us_state AS dimension, fraud_rate
FROM {{ ref('mart_fraud_by_state') }}
WHERE fraud_rate < 0 OR fraud_rate > 100

UNION ALL

SELECT 'merchant' AS mart_name, merch AS dimension, fraud_rate
FROM {{ ref('mart_merchant_analytics') }}
WHERE fraud_rate < 0 OR fraud_rate > 100
