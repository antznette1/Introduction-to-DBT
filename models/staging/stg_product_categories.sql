<<<<<<< HEAD
-- Staging model for product categories
-- Translates Portuguese category names to English

with source as (
    select *
    from {{ source('raw_data', 'product_category_name_translation') }}
=======
with source as (
    select * from {{ source('olist', 'product_category_name_translation') }}
>>>>>>> d78a5ce (feat: add staging models and configured olist sources with tests)
),

renamed as (
    select
<<<<<<< HEAD
        product_category_name as product_category_name,
        product_category_name_english as category_name
    from source
)

select *
from renamed
=======
        string_field_0 as category_name_pt,
        string_field_1 as category_name_en
    from source

    where string_field_0 != 'product_category_name'
)

select * from renamed
>>>>>>> d78a5ce (feat: add staging models and configured olist sources with tests)
