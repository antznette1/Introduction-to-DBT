# Lab 4: Marts + Testing

**Time:** 30 minutes

## Learning Objectives

- Build dimension and fact tables
- Add schema tests in YAML
- Create singular (custom) tests
- Use `dbt build`

<<<<<<< HEAD
## Key Files to Explore

### Mart Models

- `models/marts/dim_customers.sql` - Customer dimension with lifetime metrics
- `models/marts/fct_orders.sql` - Order fact table
- `models/marts/fct_daily_revenue.sql` - Daily aggregates

### Schema Tests: `models/staging/_staging.yml`

```yaml
models:
  - name: stg_orders
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
      - name: order_status
        tests:
          - accepted_values:
              values: ['delivered', 'shipped', 'canceled', ...]
```

**Built-in tests:**
- `unique` - No duplicates
- `not_null` - No NULL values
- `accepted_values` - Only specified values
- `relationships` - FK exists in another table

### Singular Tests: `tests/assert_positive_prices.sql`

```sql
-- Returns 0 rows = PASS
-- Returns any rows = FAIL

select *
from {{ ref('stg_order_items') }}
where item_price < 0
```

## Commands to Try
=======
## Step 1: Create Mart Models

Create the folder `models/marts/` and add these files:

### `models/marts/dim_customers.sql`
```sql
with orders as (
    select * from {{ ref('int_orders_enriched') }}
    where order_status = 'delivered'
),

customer_metrics as (
    select
        customer_unique_id,
        max(customer_id) as customer_id,
        max(customer_city) as city,
        max(customer_state) as state,
        count(distinct order_id) as total_orders,
        sum(order_total) as lifetime_revenue,
        avg(order_total) as avg_order_value,
        sum(item_count) as total_items,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date,
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
```

### `models/marts/fct_orders.sql`
```sql
with orders as (
    select * from {{ ref('int_orders_enriched') }}
),

final as (
    select
        order_id,
        customer_id,
        customer_unique_id,
        order_date,
        order_purchased_at,
        order_approved_at,
        order_delivered_at,
        order_estimated_delivery_at,
        customer_city,
        customer_state,
        order_status,
        delivery_status,
        item_count,
        order_subtotal,
        order_freight,
        order_total,
        days_to_delivery,
        order_status = 'delivered' as is_delivered,
        order_status = 'canceled' as is_canceled,
        delivery_status = 'late' as is_late
    from orders
)

select * from final
```

### `models/marts/fct_daily_revenue.sql`
```sql
with orders as (
    select * from {{ ref('fct_orders') }}
    where is_delivered
),

daily as (
    select
        order_date,
        count(distinct order_id) as order_count,
        count(distinct customer_unique_id) as unique_customers,
        sum(item_count) as items_sold,
        sum(order_subtotal) as subtotal_revenue,
        sum(order_freight) as freight_revenue,
        sum(order_total) as total_revenue,
        avg(order_total) as avg_order_value,
        avg(days_to_delivery) as avg_days_to_delivery,
        countif(is_late) as late_orders,
        count(distinct customer_state) as states_served
    from orders
    group by 1
),

final as (
    select
        order_date,
        extract(year from order_date) as year,
        extract(month from order_date) as month,
        extract(dayofweek from order_date) as day_of_week,
        format_date('%A', order_date) as day_name,
        order_count,
        unique_customers,
        items_sold,
        round(subtotal_revenue, 2) as subtotal_revenue,
        round(freight_revenue, 2) as freight_revenue,
        round(total_revenue, 2) as total_revenue,
        round(avg_order_value, 2) as avg_order_value,
        round(avg_days_to_delivery, 1) as avg_days_to_delivery,
        late_orders,
        states_served,
        round(sum(total_revenue) over (order by order_date), 2) as cumulative_revenue,
        round(avg(total_revenue) over (
            order by order_date
            rows between 6 preceding and current row
        ), 2) as revenue_7day_avg
    from daily
)

select * from final
order by order_date
```

## Step 2: Add Schema Tests

Create file: `models/staging/_staging.yml`

```yaml
version: 2

models:
  - name: stg_orders
    description: "Cleaned orders with standardized timestamps"
    columns:
      - name: order_id
        description: "Primary key"
        tests:
          - unique
          - not_null
      - name: customer_id
        tests:
          - not_null
      - name: order_status
        tests:
          - not_null
          - accepted_values:
              values: ['delivered', 'shipped', 'canceled', 'unavailable', 'invoiced', 'processing', 'created', 'approved']

  - name: stg_customers
    description: "Cleaned customer data"
    columns:
      - name: customer_id
        description: "Primary key"
        tests:
          - unique
          - not_null
      - name: state
        tests:
          - not_null

  - name: stg_order_items
    description: "Order line items with calculated totals"
    columns:
      - name: order_id
        tests:
          - not_null
      - name: product_id
        tests:
          - not_null
      - name: item_price
        tests:
          - not_null
      - name: item_total
        tests:
          - not_null

  - name: stg_products
    description: "Product catalog"
    columns:
      - name: product_id
        description: "Primary key"
        tests:
          - unique
          - not_null

  - name: stg_product_categories
    description: "Category translations"
    columns:
      - name: category_name_pt
        description: "Primary key"
        tests:
          - unique
          - not_null
```

Create file: `models/marts/_marts.yml`

```yaml
version: 2

models:
  - name: dim_customers
    description: "Customer dimension with lifetime metrics"
    columns:
      - name: customer_unique_id
        description: "Primary key"
        tests:
          - unique
          - not_null
      - name: lifetime_revenue
        tests:
          - not_null
      - name: customer_segment
        tests:
          - accepted_values:
              values: ['loyal', 'repeat', 'one_time']

  - name: fct_orders
    description: "Order fact table"
    columns:
      - name: order_id
        description: "Primary key"
        tests:
          - unique
          - not_null
      - name: order_total
        tests:
          - not_null
      - name: order_status
        tests:
          - not_null

  - name: fct_daily_revenue
    description: "Daily revenue aggregates"
    columns:
      - name: order_date
        description: "Primary key"
        tests:
          - unique
          - not_null
      - name: total_revenue
        tests:
          - not_null
```

## Step 3: Create Singular Tests

Create the folder `tests/` and add these files:

### `tests/assert_positive_prices.sql`
```sql
-- Fails if any prices are negative

select
    order_id,
    order_item_id,
    item_price,
    item_freight
from {{ ref('stg_order_items') }}
where item_price < 0
   or item_freight < 0
```

### `tests/assert_orders_have_items.sql`
```sql
-- Fails if delivered orders have no items

with delivered_orders as (
    select order_id
    from {{ ref('stg_orders') }}
    where order_status = 'delivered'
),

orders_with_items as (
    select distinct order_id
    from {{ ref('stg_order_items') }}
)

select o.order_id
from delivered_orders o
left join orders_with_items i on o.order_id = i.order_id
where i.order_id is null
```

## Step 4: Run and Test
>>>>>>> 1d1be8c (Starter files with lab reference SQL files)

```bash
# Run tests only
dbt test

# Run tests for staging
dbt test --select staging

# Run models + tests together
dbt build

# Run specific model + its tests
dbt build --select fct_orders
```

<<<<<<< HEAD
## ✅ Checkpoint

- [ ] Understand dim vs fct tables
- [ ] Can add schema tests in YAML
- [ ] Created a singular test
- [ ] `dbt build` passes
=======
## Checkpoint

- [ ] All mart models build successfully
- [ ] Understand dim vs fct tables
- [ ] Schema tests pass
- [ ] Singular tests pass
- [ ] `dbt build` passes

> **💡 Tip:** All the files for this lab are available in this `labs/lab_04_marts_testing/` folder. Copy them to the correct locations (`models/marts/`, `models/staging/`, `tests/`).
>
<<<<<<< HEAD
> **Stuck?** Checkout the solution branch: `git checkout lab-04-complete`
>>>>>>> 1d1be8c (Starter files with lab reference SQL files)
=======
>>>>>>> 9c07bf2 (Remove solution branches - reference files are in lab folders)
