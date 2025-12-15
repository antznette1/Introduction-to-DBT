# Lab 2: source() + ref() + Materializations

**Time:** 35 minutes

## Learning Objectives

- Understand `source()` for raw data
- Understand `ref()` for model dependencies
- Configure materializations (view vs table)

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

```sql
with orders as (
    select * from {{ ref('stg_orders') }}
),
customers as (
    select * from {{ ref('stg_customers') }}
)
...
```

**Key:** `ref()` creates dependencies. dbt runs models in the right order.

### Materializations: `dbt_project.yml`

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

## Commands to Try

```bash
# Run staging only
dbt run --select staging

# Run model + upstream dependencies
dbt run --select +int_orders_enriched

# View lineage graph
dbt docs generate
dbt docs serve
```

## ✅ Checkpoint

- [ ] Understand source() vs ref()
- [ ] Can explain why materializations matter
- [ ] Can view lineage in dbt docs
