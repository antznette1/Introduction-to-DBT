{% macro limit_in_dev(n=1000) %}
    {% if target.name == 'dev' %}
        limit {{ n }}
    {% endif %}
{% endmacro %}
