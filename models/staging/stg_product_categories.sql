-- Staging model for product categories
-- Translates Portuguese category names to English

with source as (
    select *
    from {{ source('raw_data', 'product_category_name_translation') }}
),

renamed as (
    select
        product_category_name as product_category_name,
        product_category_name_english as category_name
    from source
)

select *
from renamed
