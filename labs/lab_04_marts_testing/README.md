# Lab 4: Marts + Testing

**Time:** 30 minutes

## Learning Objectives

- Build dimension and fact tables
- Add schema tests in YAML
- Create singular (custom) tests
- Use `dbt build`

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

## ✅ Checkpoint

- [ ] Understand dim vs fct tables
- [ ] Can add schema tests in YAML
- [ ] Created a singular test
- [ ] `dbt build` passes
