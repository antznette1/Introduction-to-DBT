-- Staging model for order items
-- This model represents the line items (products) in each order

with source as (
    select * from {{ source('raw_data', 'order_items') }}
),

renamed as (
    select
        -- IDs
        order_id,
        order_item_id,
        product_id,
        seller_id,
        
        -- Pricing
        price as item_price,
        freight_value as item_freight,
        
        -- Calculated total
        price + freight_value as item_total

    from source
)

select * from renamed
