-- Exercise 1: Create Your First Model
-- This exercise corresponds to the "Create Your First Model" slide

-- GOAL: Create a simple model that selects all delivered orders

-- TODO: Write a query that:
-- 1. Selects from the stg_orders model using ref()
-- 2. Filters to only 'delivered' status
-- 3. Selects order_id, customer_id, order_purchased_at, and order_total

-- HINT: Use {{ ref('stg_orders') }} to reference the staging model
-- HINT: Remember to join with order_items to get the total

-- YOUR CODE HERE:






-- ==============================================================================
-- SOLUTION (scroll down)
-- ==============================================================================












-- SOLUTION:

with orders as (
    select * from {{ ref('stg_orders') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

order_totals as (
    select
        order_id,
        sum(item_total) as order_total
    from order_items
    group by 1
)

select
    o.order_id,
    o.customer_id,
    o.order_purchased_at,
    ot.order_total
from orders as o
left join order_totals as ot on o.order_id = ot.order_id
where o.order_status = 'delivered'
