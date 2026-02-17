# Lab 3: Jinja + Macros + Packages

**Time:** 30 minutes

## Learning Objectives

- Use variables with `{{ var() }}`
- Write Jinja loops and conditionals
- Create custom macros
- Use dbt packages

## Key Files to Explore

### Variables: `dbt_project.yml`

```yaml
vars:
  order_status_filter: 'delivered'
  start_date: '2017-01-01'
```

**Usage:** `{{ var('order_status_filter') }}`

### Jinja Loop: `models/intermediate/int_orders_by_status.sql`

```sql
{% for status in ['delivered', 'shipped', 'canceled'] %}
countif(order_status = '{{ status }}') as {{ status }}_count
{% endfor %}
```

### Custom Macro: `macros/limit_in_dev.sql`

```sql
{% macro limit_in_dev(n=1000) %}
  {% if target.name == 'dev' %}
    limit {{ n }}
  {% endif %}
{% endmacro %}
```

**Usage:** `{{ limit_in_dev(500) }}`

### Packages: `packages.yml`

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
```

**Install:** `dbt deps`

## Commands to Try

```bash
# See compiled SQL (Jinja resolved)
dbt compile --select int_orders_by_status

# Override variable
dbt run --select my_model --vars '{"order_status_filter": "shipped"}'

# Install packages
dbt deps
```

## ✅ Checkpoint

- [ ] Understand Jinja expressions `{{ }}`
- [ ] Understand Jinja control flow `{% %}`
- [ ] Created/modified a macro
- [ ] Installed dbt_utils package
<<<<<<< HEAD
=======

> **💡 Tip:** All the files for this lab are available in this `labs/lab_03_jinja_macros/` folder. Copy them to the correct locations (`models/intermediate/`, `macros/`).
>
> **Stuck?** Checkout the solution branch: `git checkout lab-03-complete`
>>>>>>> 1d1be8c (Starter files with lab reference SQL files)
