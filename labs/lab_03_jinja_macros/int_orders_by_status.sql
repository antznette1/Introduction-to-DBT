select
    order_date,
    {% for status in ['delivered', 'shipped', 'canceled', 'invoiced', 'processing'] %}
    countif(order_status = '{{ status }}') as {{ status }}_count
    {%- if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref('stg_orders') }}
group by 1
order by 1
