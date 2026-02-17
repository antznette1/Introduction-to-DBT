with orders as (
    select * from {{ ref('fct_orders') }}
    where is_delivered
),

daily as (
    select
        order_date,
        
        -- Volume
        count(distinct order_id) as order_count,
        count(distinct customer_unique_id) as unique_customers,
        sum(item_count) as items_sold,
        
        -- Revenue
        sum(order_subtotal) as subtotal_revenue,
        sum(order_freight) as freight_revenue,
        sum(order_total) as total_revenue,
        avg(order_total) as avg_order_value,
        
        -- Delivery
        avg(days_to_delivery) as avg_days_to_delivery,
        countif(is_late) as late_orders,
        
        -- Geography
        count(distinct customer_state) as states_served

    from orders
    group by 1
),

final as (
    select
        order_date,
        
        -- Date parts
        extract(year from order_date) as year,
        extract(month from order_date) as month,
        extract(dayofweek from order_date) as day_of_week,
        format_date('%A', order_date) as day_name,
        
        -- Volume
        order_count,
        unique_customers,
        items_sold,
        
        -- Revenue
        round(subtotal_revenue, 2) as subtotal_revenue,
        round(freight_revenue, 2) as freight_revenue,
        round(total_revenue, 2) as total_revenue,
        round(avg_order_value, 2) as avg_order_value,
        
        -- Delivery
        round(avg_days_to_delivery, 1) as avg_days_to_delivery,
        late_orders,
        states_served,
        
        -- Running total
        round(sum(total_revenue) over (order by order_date), 2) as cumulative_revenue,
        
        -- 7-day moving average
        round(avg(total_revenue) over (
            order by order_date
            rows between 6 preceding and current row
        ), 2) as revenue_7day_avg

    from daily
)

select * from final
order by order_date
