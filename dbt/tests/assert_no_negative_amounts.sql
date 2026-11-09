SELECT transaction_id
FROM {{ ref('stg_transactions') }}
WHERE amount < 0
