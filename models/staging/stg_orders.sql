-- Staging model for orders
-- Cleans and standardizes real Olist order data

with source as (
    select * from {{ source('raw_data', 'orders') }}
),

renamed as (
    select
        -- IDs
        order_id,
        customer_id,
        
        -- Order details
        order_status,
        
        -- Timestamps
        cast(order_purchase_timestamp as timestamp) as order_purchased_at,
        cast(order_approved_at as timestamp) as order_approved_at,
        cast(order_delivered_carrier_date as timestamp) as order_delivered_carrier_at,
        cast(order_delivered_customer_date as timestamp) as order_delivered_customer_at,
        cast(order_estimated_delivery_date as timestamp) as order_estimated_delivery_at,
        
        -- Calculated delivery time
        case 
            when order_delivered_customer_date is not null 
            then date_diff(
                cast(order_delivered_customer_date as date),
                cast(order_purchase_timestamp as date),
                day
            )
        end as days_to_deliver,
        
        -- Is order late?
        case
            when order_delivered_customer_date is not null 
                and cast(order_delivered_customer_date as timestamp) > cast(order_estimated_delivery_date as timestamp)
            then true
            else false
        end as is_late_delivery

    from source
)

select * from renamed
