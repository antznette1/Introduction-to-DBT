with order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

categories as (
    select * from {{ ref('stg_product_categories') }}
),

final as (
    select
        -- Item
        oi.order_id,
        oi.order_item_id,
        oi.product_id,
        oi.seller_id,
        oi.item_price,
        oi.item_freight,
        oi.item_total,
        
        -- Product
        coalesce(c.category_name_en, 'unknown') as category_name,
        p.category_name_pt,
        p.weight_grams,
        
        -- Weight category
        case
            when p.weight_grams <= 500 then 'light'
            when p.weight_grams <= 2000 then 'medium'
            when p.weight_grams <= 10000 then 'heavy'
            else 'very_heavy'
        end as weight_category

    from order_items oi
    left join products p on oi.product_id = p.product_id
    left join categories c on p.category_name_pt = c.category_name_pt
)

select * from final
