# Testing Your dbt Connection

## Step 1: Install dbt-bigquery

```bash
pip install dbt-bigquery
```

## Step 2: Create profiles.yml

Create the file `~/.dbt/profiles.yml` with the following content:

```yaml
dbt_intro_olist:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: dbt-intro-training  # Your GCP project ID
      dataset: dbt_dev_yourname     # Replace 'yourname' with your name
      threads: 4
      timeout_seconds: 300
      location: US
      keyfile: /path/to/your/gcp-key.json  # Path to your service account JSON file
      
    prod:
      type: bigquery
      method: service-account
      project: dbt-intro-training
      dataset: dbt_prod
      threads: 4
      timeout_seconds: 300
      location: US
      keyfile: /path/to/your/gcp-key.json
```

**Replace:**
- `yourname` with your actual name (e.g., `dbt_dev_john`)
- `/path/to/your/gcp-key.json` with the actual path to your JSON key file

---

## Step 3: Test the Connection

In the project directory, run:

```bash
dbt debug
```

**Expected output:**
```
Running with dbt=1.7.x
dbt version: 1.7.x
python version: 3.x.x
...
Connection test: [OK connection ok]
```

---

## Step 4: Install dbt Dependencies

```bash
dbt deps
```

---

## Step 5: Run Your First dbt Command

```bash
dbt run
```

If this works, you should see models being built in BigQuery!

---

## Troubleshooting

### Error: "Could not find profile"
- Make sure `profiles.yml` is in `~/.dbt/` directory
- Check that the profile name matches `dbt_project.yml`

### Error: "Credentials do not authorize"
- Verify your service account has BigQuery Admin role
- Check the path to your JSON key file is correct

### Error: "Dataset not found"
- Make sure you created the `dbt_dev_yourname` dataset in BigQuery
- Check spelling of dataset name in profiles.yml

---

## Next Steps

Once `dbt debug` shows "OK connection ok", you're ready to start building models! 🎉

Proceed to the exercises in the `exercises/` folder.
