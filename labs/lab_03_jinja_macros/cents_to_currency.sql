{% macro cents_to_currency(column_name, decimal_places=2) %}
    round(cast({{ column_name }} as numeric), {{ decimal_places }})
{% endmacro %}
