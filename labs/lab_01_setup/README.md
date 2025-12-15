# Lab 1: Setup BigQuery + dbt

**Time:** 20 minutes

## Step 1: Create GCP Project

1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Create new project or select existing
3. Note your **Project ID**

## Step 2: Enable BigQuery API

1. Go to **APIs & Services** → **Enable APIs**
2. Search "BigQuery API" → **Enable**

## Step 3: Create Service Account

1. Go to **IAM & Admin** → **Service Accounts**
2. Click **Create Service Account**
3. Name: `dbt-service-account`
4. Grant role: **BigQuery Admin**
5. Click **Keys** → **Add Key** → **JSON**
6. Save the downloaded file

## Step 4: Setup dbt

```bash
# Create dbt directory
mkdir -p ~/.dbt

# Move your key file
mv ~/Downloads/your-key-file.json ~/.dbt/service_account.json

# Copy profiles template
cp profiles_example.yml ~/.dbt/profiles.yml
```

Edit `~/.dbt/profiles.yml`:
- Replace `YOUR_GCP_PROJECT_ID`
- Replace `yourname`

## Step 5: Install dbt

```bash
python -m venv venv
source venv/bin/activate
pip install dbt-bigquery
```

## Step 6: Test Connection

```bash
dbt debug
```

All checks should pass ✓

## Step 7: Load Data to BigQuery

Create dataset `raw_olist` and upload CSVs from `data/` folder.

Or use CLI:
```bash
bq mk --dataset YOUR_PROJECT:raw_olist
bq load --source_format=CSV --autodetect raw_olist.orders data/orders.csv
bq load --source_format=CSV --autodetect raw_olist.customers data/customers.csv
bq load --source_format=CSV --autodetect raw_olist.order_items data/order_items.csv
bq load --source_format=CSV --autodetect raw_olist.products data/products.csv
bq load --source_format=CSV --autodetect raw_olist.product_category_name_translation data/product_category_name_translation.csv
```

## Step 8: Run dbt

```bash
dbt deps    # Install packages
dbt run     # Run all models
dbt test    # Run all tests
```

## ✅ Checkpoint

- [ ] `dbt debug` passes
- [ ] Data loaded to BigQuery
- [ ] `dbt run` completes
- [ ] `dbt test` passes
