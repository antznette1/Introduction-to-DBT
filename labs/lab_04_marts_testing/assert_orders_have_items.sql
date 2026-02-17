-- Fails if delivered orders have no items

with delivered_orders as (
    select order_id
    from {{ ref('stg_orders') }}
    where order_status = 'delivered'
),

orders_with_items as (
    select distinct order_id
    from {{ ref('stg_order_items') }}
)

select o.order_id
from delivered_orders o
left join orders_with_items i on o.order_id = i.order_id
where i.order_id is null
