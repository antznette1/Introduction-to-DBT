#!/bin/bash

# Load Olist data to BigQuery
# Make sure you've completed Step 1 (GCP setup) first!

# Set your project ID
PROJECT_ID="dbt-intro-training"
DATASET="raw_data"

echo "Loading data to BigQuery..."
echo "Project: $PROJECT_ID"
echo "Dataset: $DATASET"
echo ""

# Load orders
echo "Loading orders..."
bq load \
  --source_format=CSV \
  --autodetect \
  --replace \
  $PROJECT_ID:$DATASET.orders \
  ../data/orders.csv

# Load order_items
echo "Loading order_items..."
bq load \
  --source_format=CSV \
  --autodetect \
  --replace \
  $PROJECT_ID:$DATASET.order_items \
  ../data/order_items.csv

# Load customers
echo "Loading customers..."
bq load \
  --source_format=CSV \
  --autodetect \
  --replace \
  $PROJECT_ID:$DATASET.customers \
  ../data/customers.csv

# Load products
echo "Loading products..."
bq load \
  --source_format=CSV \
  --autodetect \
  --replace \
  $PROJECT_ID:$DATASET.products \
  ../data/products.csv

# Load product_categories
echo "Loading product_categories..."
bq load \
  --source_format=CSV \
  --autodetect \
  --replace \
  $PROJECT_ID:$DATASET.product_categories \
  ../data/product_categories.csv

echo ""
echo "✅ All data loaded successfully!"
echo ""
echo "Verify in BigQuery console:"
echo "1. Go to https://console.cloud.google.com/bigquery"
echo "2. Expand '$PROJECT_ID' project"
echo "3. Click on '$DATASET' dataset"
echo "4. You should see 5 tables: orders, order_items, customers, products, product_categories"
