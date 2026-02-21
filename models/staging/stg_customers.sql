<<<<<<< HEAD
-- Staging model for customers
-- Standardizes real Brazilian customer locations

with source as (
    select * from {{ source('raw_data', 'customers') }}
=======
with source as (
    select * from {{ source('olist', 'customers') }}
>>>>>>> d78a5ce (feat: add staging models and configured olist sources with tests)
),

renamed as (
    select
<<<<<<< HEAD
        -- IDs
        customer_id,
        customer_unique_id,
        
        -- Location (real Brazilian cities)
        customer_city,
        customer_state,
        customer_zip_code_prefix,
        
        -- Standardized state code
        upper(trim(customer_state)) as customer_state_clean

=======
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix as zip_code,
        lower(trim(customer_city)) as city,
        upper(customer_state) as state
>>>>>>> d78a5ce (feat: add staging models and configured olist sources with tests)
    from source
)

select * from renamed
