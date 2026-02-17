with orders as (
    select * from {{ ref('int_orders_enriched') }}
),

final as (
    select
        -- Keys
        order_id,
        customer_id,
        customer_unique_id,
        
        -- Dates
        order_date,
        order_purchased_at,
        order_approved_at,
        order_delivered_at,
        order_estimated_delivery_at,
        
        -- Location
        customer_city,
        customer_state,
        
        -- Status
        order_status,
        delivery_status,
        
        -- Metrics
        item_count,
        order_subtotal,
        order_freight,
        order_total,
        days_to_delivery,
        
        -- Flags
        order_status = 'delivered' as is_delivered,
        order_status = 'canceled' as is_canceled,
        delivery_status = 'late' as is_late

    from orders
)

select * from final
