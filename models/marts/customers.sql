-- Customers mart
-- This model aggregates customer-level metrics

with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

-- Aggregate order items to order level
order_totals as (
    select
        order_id,
        sum(item_total) as order_total,
        sum(item_price) as order_subtotal,
        sum(item_freight) as order_freight,
        count(*) as order_items_count
    from order_items
    group by order_id
),

-- Join orders with totals
orders_enriched as (
    select
        o.order_id,
        o.customer_id,
        o.order_status,
        o.order_purchased_at,
        ot.order_total,
        ot.order_subtotal,
        ot.order_freight,
        ot.order_items_count
    from orders as o
    left join order_totals as ot
        on o.order_id = ot.order_id
),

-- Aggregate to customer level
customer_metrics as (
    select
        customer_id,
        count(distinct order_id) as lifetime_orders,
        sum(order_total) as lifetime_value,
        avg(order_total) as avg_order_value,
        sum(order_items_count) as lifetime_items,
        min(order_purchased_at) as first_order_date,
        max(order_purchased_at) as most_recent_order_date
    from orders_enriched
    where order_status = 'delivered'  -- Only count completed orders
    group by customer_id
)

-- Final output
select
    c.customer_id,
    c.customer_city,
    c.customer_state_clean as customer_state,
    c.customer_zip_code_prefix as customer_zip_code,

    coalesce(cm.lifetime_orders, 0) as lifetime_orders,
    coalesce(cm.lifetime_value, 0) as lifetime_value,
    coalesce(cm.avg_order_value, 0) as avg_order_value,
    coalesce(cm.lifetime_items, 0) as lifetime_items,
    cm.first_order_date,
    cm.most_recent_order_date,

    -- Customer segment
    case
        when coalesce(cm.lifetime_value, 0) >= 500 then 'High Value'
        when coalesce(cm.lifetime_value, 0) >= 200 then 'Medium Value'
        else 'Low Value'
    end as customer_segment

from customers as c
left join customer_metrics as cm
    on c.customer_id = cm.customer_id
