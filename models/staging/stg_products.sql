<<<<<<< HEAD
-- Staging model for products
-- Cleans real Olist product catalog

with source as (
    select * from {{ source('raw_data', 'products') }}
=======
with source as (
    select * from {{ source('olist', 'products') }}
>>>>>>> d78a5ce (feat: add staging models and configured olist sources with tests)
),

renamed as (
    select
<<<<<<< HEAD
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

=======
        product_id,
        product_category_name as category_name_pt,
        cast(product_name_lenght as int64) as name_length,
        cast(product_description_lenght as int64) as description_length,
        cast(product_photos_qty as int64) as photos_count,
        cast(product_weight_g as numeric) as weight_grams,
        cast(product_length_cm as numeric) as length_cm,
        cast(product_height_cm as numeric) as height_cm,
        cast(product_width_cm as numeric) as width_cm
>>>>>>> d78a5ce (feat: add staging models and configured olist sources with tests)
    from source
)

select * from renamed
