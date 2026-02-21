with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

order_totals as (
    select
        order_id,
        count(*) as item_count,
        sum(item_price) as order_subtotal,
        sum(item_freight) as order_freight,
        sum(item_total) as order_total
    from {{ ref('stg_order_items') }}
    group by 1
),

final as (
    select
        -- Order
        o.order_id,
        o.order_status,
        o.order_date,
        o.order_purchased_at,
        o.order_approved_at,
        o.order_delivered_at,
        o.order_estimated_delivery_at,
        
        -- Customer
        o.customer_id,
        c.customer_unique_id,
        c.city as customer_city,
        c.state as customer_state,
        
        -- Totals
        coalesce(ot.item_count, 0) as item_count,
        coalesce(ot.order_subtotal, 0) as order_subtotal,
        coalesce(ot.order_freight, 0) as order_freight,
        coalesce(ot.order_total, 0) as order_total,
        
        -- Delivery
        date_diff(
            date(o.order_delivered_at),
            date(o.order_purchased_at),
            day
        ) as days_to_delivery,
        
        case
            when o.order_delivered_at <= o.order_estimated_delivery_at then 'on_time'
            when o.order_delivered_at > o.order_estimated_delivery_at then 'late'
            else 'not_delivered'
        end as delivery_status

    from orders o
    left join customers c on o.customer_id = c.customer_id
    left join order_totals ot on o.order_id = ot.order_id
)

select * from final
