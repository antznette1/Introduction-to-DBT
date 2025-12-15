-- This test fails if any orders have negative or zero totals
-- Test PASSES if query returns 0 rows

select
    order_id,
    order_total
from {{ ref('orders') }}
where order_total <= 0
