# Lab 2: source() + ref() + Materializations

**Time:** 35 minutes

## Learning Objectives

- Understand `source()` for raw data
- Understand `ref()` for model dependencies
- Configure materializations (view vs table)

<<<<<<< HEAD
## Key Files to Explore

### Sources: `models/staging/_sources.yml`

```yaml
sources:
  - name: olist
    schema: raw_olist
    tables:
      - name: orders
      - name: customers
```

**Usage:** `{{ source('olist', 'orders') }}`

### Staging Model: `models/staging/stg_orders.sql`

```sql
with source as (
    select * from {{ source('olist', 'orders') }}
)
...
```

### Intermediate Model: `models/intermediate/int_orders_enriched.sql`

=======
## Step 1: Create the Sources File

Create file: `models/staging/_sources.yml`

```yaml
version: 2

sources:
  - name: olist
    description: "Raw Olist e-commerce data"
    schema: raw_olist
    tables:
      - name: orders
        description: "Order transactions"
        columns:
          - name: order_id
            description: "Primary key"
          - name: customer_id
            description: "FK to customers"
          - name: order_status
            description: "Order status"
          - name: order_purchase_timestamp
            description: "When order was placed"
      - name: customers
        description: "Customer information"
        columns:
          - name: customer_id
            description: "Primary key"
          - name: customer_unique_id
            description: "Unique customer across orders"
          - name: customer_city
            description: "City name"
          - name: customer_state
            description: "State code"
      - name: order_items
        description: "Line items per order"
        columns:
          - name: order_id
            description: "FK to orders"
          - name: order_item_id
            description: "Item sequence"
          - name: product_id
            description: "FK to products"
          - name: price
            description: "Item price (BRL)"
          - name: freight_value
            description: "Shipping cost (BRL)"
      - name: products
        description: "Product catalog"
        columns:
          - name: product_id
            description: "Primary key"
          - name: product_category_name
            description: "Category (Portuguese)"
      - name: product_category_name_translation
        description: "Category translations"
        columns:
          - name: product_category_name
            description: "Category (Portuguese)"
          - name: product_category_name_english
            description: "Category (English)"
```

## Step 2: Create Staging Models

Create each of these files in `models/staging/`:

### `models/staging/stg_orders.sql`
```sql
with source as (
    select * from {{ source('olist', 'orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        order_status,
        cast(order_purchase_timestamp as timestamp) as order_purchased_at,
        cast(order_approved_at as timestamp) as order_approved_at,
        cast(order_delivered_carrier_date as timestamp) as order_delivered_carrier_at,
        cast(order_delivered_customer_date as timestamp) as order_delivered_at,
        cast(order_estimated_delivery_date as timestamp) as order_estimated_delivery_at,
        date(order_purchase_timestamp) as order_date
    from source
)

select * from renamed
```

### `models/staging/stg_customers.sql`
```sql
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
```

### `models/staging/stg_order_items.sql`
```sql
with source as (
    select * from {{ source('olist', 'order_items') }}
),

renamed as (
    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        cast(shipping_limit_date as timestamp) as shipping_limit_at,
        cast(price as numeric) as item_price,
        cast(freight_value as numeric) as item_freight,
        cast(price as numeric) + cast(freight_value as numeric) as item_total
    from source
)

select * from renamed
```

### `models/staging/stg_products.sql`
```sql
with source as (
    select * from {{ source('olist', 'products') }}
),

renamed as (
    select
        product_id,
        product_category_name as category_name_pt,
        cast(product_name_lenght as int64) as name_length,
        cast(product_description_lenght as int64) as description_length,
        cast(product_photos_qty as int64) as photos_count,
        cast(product_weight_g as numeric) as weight_grams,
        cast(product_length_cm as numeric) as length_cm,
        cast(product_height_cm as numeric) as height_cm,
        cast(product_width_cm as numeric) as width_cm
    from source
)

select * from renamed
```

### `models/staging/stg_product_categories.sql`
```sql
with source as (
    select * from {{ source('olist', 'product_category_name_translation') }}
),

renamed as (
    select
        product_category_name as category_name_pt,
        product_category_name_english as category_name_en
    from source
)

select * from renamed
```

## Step 3: Create Intermediate Models

Create a new folder: `models/intermediate/`

### `models/intermediate/int_orders_enriched.sql`
>>>>>>> 1d1be8c (Starter files with lab reference SQL files)
```sql
with orders as (
    select * from {{ ref('stg_orders') }}
),
<<<<<<< HEAD
customers as (
    select * from {{ ref('stg_customers') }}
)
...
```

**Key:** `ref()` creates dependencies. dbt runs models in the right order.

### Materializations: `dbt_project.yml`
=======

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
        o.order_id,
        o.order_status,
        o.order_date,
        o.order_purchased_at,
        o.order_approved_at,
        o.order_delivered_at,
        o.order_estimated_delivery_at,
        o.customer_id,
        c.customer_unique_id,
        c.city as customer_city,
        c.state as customer_state,
        coalesce(ot.item_count, 0) as item_count,
        coalesce(ot.order_subtotal, 0) as order_subtotal,
        coalesce(ot.order_freight, 0) as order_freight,
        coalesce(ot.order_total, 0) as order_total,
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
```

### `models/intermediate/int_order_items_enriched.sql`
```sql
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
        oi.order_id,
        oi.order_item_id,
        oi.product_id,
        oi.seller_id,
        oi.item_price,
        oi.item_freight,
        oi.item_total,
        coalesce(c.category_name_en, 'unknown') as category_name,
        p.category_name_pt,
        p.weight_grams,
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
```

## Step 4: Configure Materializations

Add this to the bottom of your `dbt_project.yml`:
>>>>>>> 1d1be8c (Starter files with lab reference SQL files)

```yaml
models:
  dbt_intro_olist:
    staging:
      +materialized: view      # Fast, no storage
    intermediate:
      +materialized: view
    marts:
      +materialized: table     # Stored, for BI tools
```

<<<<<<< HEAD
## Commands to Try
=======
## Step 5: Run and Verify
>>>>>>> 1d1be8c (Starter files with lab reference SQL files)

```bash
# Run staging only
dbt run --select staging

# Run model + upstream dependencies
dbt run --select +int_orders_enriched

# View lineage graph
dbt docs generate
dbt docs serve
```

<<<<<<< HEAD
## ✅ Checkpoint

- [ ] Understand source() vs ref()
- [ ] Can explain why materializations matter
- [ ] Can view lineage in dbt docs
=======
## Checkpoint

- [ ] All staging models run successfully
- [ ] Intermediate models run successfully
- [ ] Understand source() vs ref()
- [ ] Can explain why materializations matter
- [ ] Can view lineage in dbt docs

> **💡 Tip:** All the files for this lab are available in this `labs/lab_02_source_ref/` folder. Copy them to the correct locations (`models/staging/`, `models/intermediate/`).
>
<<<<<<< HEAD
> **Stuck?** Checkout the solution branch: `git checkout lab-02-complete`
>>>>>>> 1d1be8c (Starter files with lab reference SQL files)
=======
>>>>>>> 9c07bf2 (Remove solution branches - reference files are in lab folders)
