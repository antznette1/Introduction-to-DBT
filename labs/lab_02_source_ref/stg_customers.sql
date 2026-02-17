with source as (
    select * from {{ source('olist', 'customers') }}
),

renamed as (
    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix as zip_code,
        lower(trim(customer_city)) as city,
        upper(customer_state) as state
    from source
)

select * from renamed
