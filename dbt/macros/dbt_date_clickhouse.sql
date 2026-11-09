{% macro clickhouse__date_part(datepart, date) %}
    {% set datepart_functions = {
        'year': 'toYear',
        'quarter': 'toQuarter',
        'month': 'toMonth',
        'week': 'toWeek',
        'day': 'toDayOfMonth',
        'dayofweek': 'toDayOfWeek',
        'day_of_week': 'toDayOfWeek',
        'dayofyear': 'toDayOfYear',
        'hour': 'toHour',
        'minute': 'toMinute',
        'second': 'toSecond'
    } %}
    {% set normalized_datepart = datepart | lower %}
    {% if normalized_datepart not in datepart_functions %}
        {{ exceptions.raise_compiler_error('Unsupported ClickHouse date part: ' ~ datepart) }}
    {% endif %}
    {{ datepart_functions[normalized_datepart] }}({{ date }})
{% endmacro %}

{% macro clickhouse__day_name(date, short=True, language='default') %}
    {% set full_name %}
        arrayElement(
            ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
            toDayOfWeek({{ date }})
        )
    {% endset %}
    {% if short %}
        substring({{ full_name }}, 1, 3)
    {% else %}
        {{ full_name }}
    {% endif %}
{% endmacro %}
