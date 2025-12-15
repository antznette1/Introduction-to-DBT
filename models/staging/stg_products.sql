-- Staging model for products
-- Cleans real Olist product catalog

with source as (
    select * from {{ source('raw_data', 'products') }}
),

renamed as (
    select
        -- IDs
        product_id,
        product_category_name,
        
        -- Dimensions
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm,
        
        -- Calculated volume
        product_length_cm * product_height_cm * product_width_cm as product_volume_cm3

    from source
)

select * from renamed
