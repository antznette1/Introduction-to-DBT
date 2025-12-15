-- Exercise 2: Build with ref() and Macros
-- This exercise corresponds to the "Build with ref() and Macros" slide

-- GOAL: Create a product performance model using ref() and the limit_in_dev macro

-- TODO: Write a query that:
-- 1. Joins products, order_items, and categories
-- 2. Calculates total revenue per product
-- 3. Uses {{ limit_in_dev() }} macro at the end
-- 4. Orders by revenue descending

-- YOUR CODE HERE:






-- ==============================================================================
-- SOLUTION (scroll down)
-- ==============================================================================












-- SOLUTION:

with products as (
    select * from {{ ref('stg_products') }}
),

categories as (
    select * from {{ ref('stg_product_categories') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
)

select
    p.product_id,
    c.category_name,
    count(distinct oi.order_id) as orders_count,
    sum(oi.item_price) as total_revenue,
    avg(oi.item_price) as avg_price
from products as p
left join categories as c on p.product_category_id = c.product_category_id
left join order_items as oi on p.product_id = oi.product_id
group by 1, 2
order by total_revenue desc

{{ limit_in_dev(100) }}
