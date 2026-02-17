with orders as (
    select * from {{ ref('int_orders_enriched') }}
    where order_status = 'delivered'
),

customer_metrics as (
    select
        customer_unique_id,
        
        -- Latest info
        max(customer_id) as customer_id,
        max(customer_city) as city,
        max(customer_state) as state,
        
        -- Order metrics
        count(distinct order_id) as total_orders,
        sum(order_total) as lifetime_revenue,
        avg(order_total) as avg_order_value,
        sum(item_count) as total_items,
        
        -- Dates
        min(order_date) as first_order_date,
        max(order_date) as last_order_date,
        
        -- Delivery
        avg(days_to_delivery) as avg_days_to_delivery,
        countif(delivery_status = 'late') as late_deliveries

    from orders
    group by 1
),

final as (
    select
        customer_unique_id,
        customer_id,
        city,
        state,
        total_orders,
        round(lifetime_revenue, 2) as lifetime_revenue,
        round(avg_order_value, 2) as avg_order_value,
        total_items,
        first_order_date,
        last_order_date,
        round(avg_days_to_delivery, 1) as avg_days_to_delivery,
        late_deliveries,
        
        -- Segments
        case
            when total_orders >= 3 then 'loyal'
            when total_orders = 2 then 'repeat'
            else 'one_time'
        end as customer_segment,
        
        case
            when lifetime_revenue >= 1000 then 'high_value'
            when lifetime_revenue >= 300 then 'medium_value'
            else 'low_value'
        end as value_segment

    from customer_metrics
)

select * from final
