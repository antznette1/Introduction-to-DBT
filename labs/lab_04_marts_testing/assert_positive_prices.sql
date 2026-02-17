-- Fails if any prices are negative

select
    order_id,
    order_item_id,
    item_price,
    item_freight
from {{ ref('stg_order_items') }}
where item_price < 0
   or item_freight < 0
