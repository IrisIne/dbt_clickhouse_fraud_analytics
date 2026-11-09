{% macro customer_risk_level(fraud_rate_column, fraud_count_column, average_amount_column) %}
    multiIf(
        {{ fraud_rate_column }} >= 20 OR {{ fraud_count_column }} >= 2, 'HIGH',
        {{ fraud_rate_column }} >= 5 OR {{ average_amount_column }} >= 500, 'MEDIUM',
        'LOW'
    )
{% endmacro %}
