{{ config(materialized='view') }}

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'transaction_time',
        'merch',
        'name_1',
        'name_2',
        'amount',
        'lat',
        'lon',
        'merchant_lat',
        'merchant_lon'
    ]) }} AS transaction_id,
    {{ dbt_utils.generate_surrogate_key([
        'name_1',
        'name_2',
        'street',
        'post_code'
    ]) }} AS customer_id,
    {{ dbt_utils.generate_surrogate_key(['merch']) }} AS merchant_id,
    toDateTime(transaction_time) AS transaction_time,
    toDate(transaction_time) AS transaction_date,
    {{ dbt_date.date_part('hour', 'transaction_time') }} AS transaction_hour,
    {{ dbt_date.day_of_week('transaction_time') }} AS day_of_week_number,
    {{ dbt_date.day_name('transaction_time', short=false) }} AS day_of_week_name,
    trim(toString(merch)) AS merch,
    lower(trim(toString(cat_id))) AS cat_id,
    toDecimal64(amount, 2) AS amount,
    {{ amount_bucket('amount') }} AS amount_bucket,
    toUInt8(amount >= 500) AS is_large_transaction,
    trim(toString(name_1)) AS name_1,
    trim(toString(name_2)) AS name_2,
    concat(trim(toString(name_1)), ' ', trim(toString(name_2))) AS customer_name,
    upper(trim(toString(gender))) AS gender,
    trim(toString(street)) AS street,
    trim(toString(one_city)) AS one_city,
    upper(trim(toString(us_state))) AS us_state,
    trim(toString(post_code)) AS post_code,
    toFloat64(lat) AS lat,
    toFloat64(lon) AS lon,
    toUInt32(population_city) AS population_city,
    trim(toString(jobs)) AS jobs,
    toFloat64(merchant_lat) AS merchant_lat,
    toFloat64(merchant_lon) AS merchant_lon,
    round(greatCircleDistance(lon, lat, merchant_lon, merchant_lat) / 1000, 3) AS merchant_distance_km,
    toUInt8(target) AS fraud_flag
FROM {{ source('transactions_raw', 'transactions') }}
