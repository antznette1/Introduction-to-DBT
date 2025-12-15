-- Staging model for customers
-- Standardizes real Brazilian customer locations

with source as (
    select * from {{ source('raw_data', 'customers') }}
),

renamed as (
    select
        -- IDs
        customer_id,
        customer_unique_id,
        
        -- Location (real Brazilian cities)
        customer_city,
        customer_state,
        customer_zip_code_prefix,
        
        -- Standardized state code
        upper(trim(customer_state)) as customer_state_clean

    from source
)

select * from renamed
