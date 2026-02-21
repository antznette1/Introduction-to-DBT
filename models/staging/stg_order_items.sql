<<<<<<< HEAD
-- Staging model for order items
-- This model represents the line items (products) in each order

with source as (
    select * from {{ source('raw_data', 'order_items') }}
=======
with source as (
    select * from {{ source('olist', 'order_items') }}
>>>>>>> d78a5ce (feat: add staging models and configured olist sources with tests)
),

renamed as (
    select
<<<<<<< HEAD
        -- IDs
=======
>>>>>>> d78a5ce (feat: add staging models and configured olist sources with tests)
        order_id,
        order_item_id,
        product_id,
        seller_id,
<<<<<<< HEAD
        
        -- Pricing
        price as item_price,
        freight_value as item_freight,
        
        -- Calculated total
        price + freight_value as item_total

=======
        cast(shipping_limit_date as timestamp) as shipping_limit_at,
        cast(price as numeric) as item_price,
        cast(freight_value as numeric) as item_freight,
        cast(price as numeric) + cast(freight_value as numeric) as item_total
>>>>>>> d78a5ce (feat: add staging models and configured olist sources with tests)
    from source
)

select * from renamed
