{% macro amount_bucket(column_name) %}
    multiIf(
        {{ column_name }} < 20, 'SMALL',
        {{ column_name }} < 100, 'MEDIUM',
        {{ column_name }} < 500, 'LARGE',
        'VERY_LARGE'
    )
{% endmacro %}
