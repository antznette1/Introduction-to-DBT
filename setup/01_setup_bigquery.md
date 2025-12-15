# Setting Up BigQuery for dbt Intro Course

## Prerequisites
- Google Cloud Platform account (free tier works!)
- Basic command line knowledge

---

## Step 1: Create a GCP Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click "Select a Project" → "New Project"
3. Project name: `dbt-intro-training`
4. Click "Create"

---

## Step 2: Enable BigQuery API

1. In the GCP Console, go to "APIs & Services" → "Library"
2. Search for "BigQuery API"
3. Click "Enable"

---

## Step 3: Create a Service Account

1. Go to "IAM & Admin" → "Service Accounts"
2. Click "Create Service Account"
3. Name: `dbt-user`
4. Description: `Service account for dbt training`
5. Click "Create and Continue"

**Grant roles:**
- BigQuery Admin
- BigQuery Job User

6. Click "Continue" → "Done"

---

## Step 4: Create Service Account Key

1. Click on the service account you just created
2. Go to "Keys" tab
3. Click "Add Key" → "Create new key"
4. Choose JSON format
5. Click "Create"
6. **Save the downloaded JSON file** to a safe location
   - Example: `~/.dbt/gcp-key.json`

---

## Step 5: Create BigQuery Datasets

Run these commands in the BigQuery console or using `bq` CLI:

```sql
-- Create raw data dataset
CREATE SCHEMA IF NOT EXISTS `dbt-intro-training.raw_data`
OPTIONS(
  location="US"
);

-- Create dev dataset (your personal workspace)
CREATE SCHEMA IF NOT EXISTS `dbt-intro-training.dbt_dev_yourname`
OPTIONS(
  location="US"
);

-- Create prod dataset (for later)
CREATE SCHEMA IF NOT EXISTS `dbt-intro-training.dbt_prod`
OPTIONS(
  location="US"
);
```

**Replace `yourname` with your actual name** (e.g., `dbt_dev_john`)

---

## Step 6: Verify Setup

In BigQuery console, you should now see:
- ✅ Project: `dbt-intro-training`
- ✅ Datasets: `raw_data`, `dbt_dev_yourname`, `dbt_prod`

---

## Next Steps

Proceed to: **02_load_data_to_bigquery.md**
