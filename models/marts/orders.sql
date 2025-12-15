-- Orders mart
-- Enriched order information from real Olist data

with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

categories as (
    select * from {{ ref('stg_product_categories') }}
),

-- Aggregate items to order level
order_totals as (
    select
        order_id,
        sum(item_total) as order_total,
        sum(item_price) as order_subtotal,
        sum(item_freight) as order_freight,
        count(*) as order_items_count,
        count(distinct product_id) as unique_products
    from order_items
    group by 1
),

-- Get primary product category per order
order_categories as (
    select
        oi.order_id,
        c.category_name,
        row_number() over (
            partition by oi.order_id 
            order by oi.item_total desc
        ) as category_rank
    from order_items as oi
    left join products as p on oi.product_id = p.product_id
    left join categories as c on p.product_category_name = c.product_category_name
),

primary_category as (
    select
        order_id,
        category_name as primary_category
    from order_categories
    where category_rank = 1
)

-- Final output
select
    o.order_id,
    o.customer_id,
    c.customer_city,
    c.customer_state,
    
    o.order_status,
    o.order_purchased_at,
    o.order_delivered_customer_at,
    o.order_estimated_delivery_at,
    o.days_to_deliver,
    o.is_late_delivery,
    
    ot.order_total,
    ot.order_subtotal,
    ot.order_freight,
    ot.order_items_count,
    ot.unique_products,
    
    pc.primary_category

from orders as o
left join customers as c on o.customer_id = c.customer_id
left join order_totals as ot on o.order_id = ot.order_id
left join primary_category as pc on o.order_id = pc.order_id
