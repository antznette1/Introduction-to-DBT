# Lab 5: Documentation + Freshness

**Time:** 25 minutes

## Learning Objectives

- Add descriptions to models and columns
- Configure source freshness
- Generate and explore documentation

<<<<<<< HEAD
## Key Files to Explore

### Documentation: `models/marts/_marts.yml`

```yaml
=======
## Step 1: Add Descriptions to Marts

Update your `models/marts/_marts.yml` to add detailed descriptions:

```yaml
version: 2

>>>>>>> 1d1be8c (Starter files with lab reference SQL files)
models:
  - name: dim_customers
    description: |
      Customer dimension with lifetime metrics.
      
      **Grain:** One row per customer_unique_id
      
<<<<<<< HEAD
      **Use for:** Customer segmentation, lifetime value
=======
      **Use for:** Customer segmentation, lifetime value analysis
>>>>>>> 1d1be8c (Starter files with lab reference SQL files)
    columns:
      - name: customer_unique_id
        description: "Primary key"
        tests:
          - unique
<<<<<<< HEAD
```

### Source Freshness: `models/staging/_sources.yml`

```yaml
sources:
  - name: olist
=======
          - not_null
      - name: lifetime_revenue
        tests:
          - not_null
      - name: customer_segment
        tests:
          - accepted_values:
              values: ['loyal', 'repeat', 'one_time']

  - name: fct_orders
    description: |
      Order fact table.
      
      **Grain:** One row per order
      
      **Use for:** Revenue analysis, delivery tracking
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
    description: |
      Daily revenue aggregates.
      
      **Grain:** One row per day
      
      **Use for:** Dashboards, trend analysis
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

## Step 2: Add Source Freshness

Update your `models/staging/_sources.yml` to add freshness checks:

Add this under the `olist` source (before `tables:`):

```yaml
>>>>>>> 1d1be8c (Starter files with lab reference SQL files)
    freshness:
      warn_after:
        count: 24
        period: hour
      error_after:
        count: 48
        period: hour
<<<<<<< HEAD
    tables:
      - name: orders
        loaded_at_field: order_purchase_timestamp
```

## Commands to Try
=======
```

And add `loaded_at_field` to the orders table:

```yaml
      - name: orders
        description: "Order transactions"
        loaded_at_field: order_purchase_timestamp
```

## Step 3: Generate and Explore Docs
>>>>>>> 1d1be8c (Starter files with lab reference SQL files)

```bash
# Generate docs
dbt docs generate

# Serve docs (opens browser)
dbt docs serve

# Check freshness
dbt source freshness
```

## What to Explore in Docs

1. Search for `dim_customers`
2. Read the description
3. See column details and tests
4. Click lineage graph icon (bottom right)
<<<<<<< HEAD
5. Trace data flow from sources → marts

## ✅ Checkpoint
=======
5. Trace data flow from sources to marts

## Checkpoint
>>>>>>> 1d1be8c (Starter files with lab reference SQL files)

- [ ] Can navigate dbt docs
- [ ] Understand lineage graph
- [ ] Can check source freshness
- [ ] All models documented

---

<<<<<<< HEAD
## 🎉 Complete!

You now know:
- ✅ Setup dbt with BigQuery
- ✅ source() and ref()
- ✅ Materializations
- ✅ Jinja templating
- ✅ Custom macros
- ✅ dbt packages
- ✅ Schema and singular tests
- ✅ Documentation
- ✅ Source freshness
=======
## Complete!

You now know:
- Setup dbt with BigQuery
- source() and ref()
- Materializations
- Jinja templating
- Custom macros
- dbt packages
- Schema and singular tests
- Documentation
- Source freshness

> **💡 Tip:** Updated YAML files for this lab are available in this `labs/lab_05_docs_freshness/` folder. Copy them to replace your existing files in `models/staging/` and `models/marts/`.
>
> **Stuck?** Checkout the solution branch: `git checkout lab-05-complete`
>>>>>>> 1d1be8c (Starter files with lab reference SQL files)
