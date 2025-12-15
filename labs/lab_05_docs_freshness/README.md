# Lab 5: Documentation + Freshness

**Time:** 25 minutes

## Learning Objectives

- Add descriptions to models and columns
- Configure source freshness
- Generate and explore documentation

## Key Files to Explore

### Documentation: `models/marts/_marts.yml`

```yaml
models:
  - name: dim_customers
    description: |
      Customer dimension with lifetime metrics.
      
      **Grain:** One row per customer_unique_id
      
      **Use for:** Customer segmentation, lifetime value
    columns:
      - name: customer_unique_id
        description: "Primary key"
        tests:
          - unique
```

### Source Freshness: `models/staging/_sources.yml`

```yaml
sources:
  - name: olist
    freshness:
      warn_after:
        count: 24
        period: hour
      error_after:
        count: 48
        period: hour
    tables:
      - name: orders
        loaded_at_field: order_purchase_timestamp
```

## Commands to Try

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
5. Trace data flow from sources → marts

## ✅ Checkpoint

- [ ] Can navigate dbt docs
- [ ] Understand lineage graph
- [ ] Can check source freshness
- [ ] All models documented

---

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
