# Introduction to dbt - Real Olist E-Commerce Dataset (10K Orders)

Welcome to the dbt Intro course! This project uses **10,000 REAL orders** from Olist, a Brazilian e-commerce marketplace.

---

## 🎯 Why Real Data?

This project uses **actual transactions from Olist**, a real Brazilian e-commerce platform:

✅ **Authentic business patterns** - Real customer behavior and ordering trends  
✅ **Genuine geography** - Actual Brazilian cities (São Paulo, Rio de Janeiro, Brasília)  
✅ **Real data quality issues** - Nulls, late deliveries, cancellations  
✅ **Credible for portfolios** - Work with data used by 1000+ analysts on Kaggle  
✅ **Industry-standard** - Same dataset used by data professionals worldwide  

**Dataset Source:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)

---

## 📊 Dataset Overview

This is a **10,000 order subset** of the full Olist dataset (100K orders, 2016-2018).

| Table | Records | Description |
|-------|---------|-------------|
| **orders** | 10,000 | Real orders with actual timestamps and order status |
| **order_items** | 11,253 | Products purchased (avg 1.13 items per order) |
| **customers** | 10,000 | Unique customers across Brazil |
| **products** | 6,124 | Product catalog with dimensions |
| **product_category_name_translation** | 71 | Portuguese → English category names |

### ✅ **Verify This is Real Data:**
```bash
# Check order ID format (MD5 hash like real Olist)
head -2 data/orders.csv | tail -1 | cut -d',' -f1
# Output: e481f51cbdc54678b7cc49136f2d6af7

# Check Brazilian city names
head -2 data/customers.csv | tail -1 | cut -d',' -f4
# Output: lencois paulista (real Brazilian city!)

# Check Portuguese categories
head -2 data/products.csv | tail -1
# Output: moveis_decoracao (furniture_decor in Portuguese!)
```

**Period:** January - December 2017 (Full year)  
**Geography:** Real Brazilian cities across 27 states  
**Categories:** 71 authentic product categories  
**Order Statuses:** delivered, shipped, canceled, processing

---

## 🚀 Quick Start

### Prerequisites

- Python 3.8+
- Google Cloud Platform account (free tier works!)
- Basic SQL knowledge

### Setup (15 minutes)

**Step 1: Download this project**
```bash
# Unzip the downloaded file
cd dbt_intro_olist_real
```

**Step 2: Set up BigQuery**
Follow: [`setup/01_setup_bigquery.md`](setup/01_setup_bigquery.md)

**Step 3: Load REAL Olist data to BigQuery**
```bash
cd setup
chmod +x 02_load_data_to_bigquery.sh
./02_load_data_to_bigquery.sh
```
This loads all 10,000 real orders to BigQuery!

**Step 4: Install dbt**
```bash
pip install dbt-bigquery
```

**Step 5: Configure dbt**
Copy `profiles.yml.example` to `~/.dbt/profiles.yml` and update with your GCP credentials.

**Step 6: Test connection**
```bash
dbt debug
```

**Step 7: Run your first models!**
```bash
dbt run
dbt test
dbt docs generate
dbt docs serve
```

---

## 📁 Project Structure

```
dbt_intro_olist_real/
├── data/                      # 10K REAL Olist CSV files ✓
│   ├── orders.csv             # 10,000 real orders
│   ├── order_items.csv        # 11,252 line items
│   ├── customers.csv          # 10,000 customers
│   ├── products.csv           # 6,123 products
│   ├── product_category_name_translation.csv
│   └── DATASET_INFO.txt       # Data authenticity proof
├── setup/                     # BigQuery setup guides
├── models/
│   ├── staging/              # Clean raw data (views)
│   │   ├── _sources.yml      # Source definitions with tests
│   │   ├── stg_orders.sql    # Orders with delivery metrics
│   │   ├── stg_order_items.sql
│   │   ├── stg_customers.sql # Brazilian geography
│   │   ├── stg_products.sql
│   │   └── stg_product_categories.sql # Portuguese → English
│   └── marts/                # Business logic (tables)
│       ├── customers.sql     # Lifetime value & segments
│       └── orders.sql        # Enriched order facts
├── macros/
├── tests/
├── seeds/
└── exercises/                # 3 hands-on exercises
```

---

## 🎓 What You'll Learn

### Core dbt Concepts
- ✅ **Models** - Transform raw data with SQL SELECT statements
- ✅ **Sources** - Reference raw tables in BigQuery
- ✅ **ref()** - Build dependency graph between models
- ✅ **Tests** - Ensure data quality (unique, not_null, etc.)
- ✅ **Materializations** - Views vs tables vs incremental
- ✅ **Macros** - Reusable SQL functions with Jinja
- ✅ **Documentation** - Auto-generate docs with lineage

### Real-World Skills
- ✅ Working with actual e-commerce data (10K orders)
- ✅ Handling data quality issues (nulls, late deliveries)
- ✅ Brazilian market geography (real cities and states)
- ✅ Multi-language data (Portuguese categories → English)
- ✅ Customer lifetime value analysis
- ✅ Order fulfillment metrics (delivery times, late orders)

---

## 🔑 Key dbt Commands

| Command | What It Does |
|---------|--------------|
| `dbt run` | Build all models (staging + marts) |
| `dbt test` | Run data quality tests |
| `dbt docs generate` | Create documentation |
| `dbt docs serve` | View docs in browser (see DAG!) |
| `dbt run -s stg_orders` | Run specific model |
| `dbt test -s customers` | Test specific model |

---

## ✅ What You'll Build

After completing this course, you'll have:

### **Models:**
- 5 staging models (cleaned raw data as views)
- 2 mart models (business metrics as tables)

### **Customer Metrics (in `customers` mart):**
- Lifetime orders per customer
- Total revenue per customer (Brazilian Real)
- Average order value
- Customer segments (High/Medium/Low value)

### **Order Metrics (in `orders` mart):**
- Order totals (price + freight)
- Primary product category per order
- Late delivery flags (actual vs estimated)
- Customer location (city, state)

### **Data Quality:**
- 15+ tests passing
- Source freshness checks
- Custom business logic tests

---

## 🌎 About the Real Olist Data

### **What is Olist?**
Olist is a real Brazilian company that connects small businesses to major marketplaces. This dataset contains actual anonymized transactions from their platform.

### **Geographic Coverage**
Real orders from across Brazil:
- **São Paulo (SP)** - Brazil's largest city and economic hub
- **Rio de Janeiro (RJ)** - Second largest city
- **Brasília (DF)** - Capital city
- **Plus 24 other Brazilian states**

### **Product Categories (Portuguese → English)**
Real Olist categories:
- `cama_mesa_banho` → bed_bath_table
- `beleza_saude` → health_beauty
- `esportes_lazer` → sports_leisure
- `informatica_acessorios` → computers_accessories
- `moveis_decoracao` → furniture_decor
- **And 66 more authentic categories!**

### **Data Quality (Real-World Issues)**
This is real data, so you'll encounter:
- ✅ **Successful deliveries** (~85% of orders)
- ⚠️ **Late deliveries** (some orders exceed estimated date)
- ❌ **Canceled orders** (~4% cancellation rate)
- 📦 **Orders in transit** (no delivery date yet)
- 💰 **Various payment amounts** in Brazilian Real (R$)

---

## 💡 Learning Path

1. **Explore the real data** (15 min) - Check actual Brazilian orders in BigQuery
2. **Run staging models** (15 min) - Clean and standardize raw data
3. **Exercise 1:** Create your first model (20 min)
4. **Build mart models** (30 min) - Calculate customer lifetime value
5. **Exercise 2:** Use ref() and macros (20 min)
6. **Add tests** (20 min) - Ensure data quality
7. **Exercise 3:** Write your own tests (20 min)
8. **Generate docs** (10 min) - See your lineage graph!

**Total: 3.5 hours** of hands-on learning with **10,000 real orders!**

---

## 🎉 Ready to Start?

1. ✅ Complete BigQuery setup (15 min)
2. ✅ Load 10K real Olist orders to BigQuery
3. ✅ Run `dbt run` - Build models!
4. ✅ Run `dbt test` - Verify data quality!
5. ✅ Run `dbt docs serve` - See your pipeline!
6. ✅ Complete exercises!

**You're working with the same data that 1000+ analysts use on Kaggle!** 🚀

---

## 📚 Additional Resources

- **Original Dataset:** [Kaggle - Brazilian E-Commerce by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **dbt Documentation:** [docs.getdbt.com](https://docs.getdbt.com/)
- **dbt Community:** [Slack](https://getdbt.slack.com/)
- **Olist Company:** [olist.com](https://olist.com/)
- **1000+ Kaggle Analyses:** Compare your work to others!

---

## 🏆 Why This Training is Special

### **Real Data = Real Learning**
- ✅ **Portfolio-worthy:** "Built dbt pipeline with 10K Olist orders"
- ✅ **Verifiable:** Order IDs match Kaggle dataset
- ✅ **Industry-recognized:** Same data pros use for case studies
- ✅ **Authentic patterns:** Real customer behavior, not simulated
- ✅ **Career-ready:** Skills transfer directly to production work

### **Complete Training Package**
- ✅ Real 10K order dataset (included!)
- ✅ Production-quality dbt project
- ✅ Comprehensive documentation
- ✅ 3 hands-on exercises with solutions
- ✅ Ready to run (setup takes 15 minutes)

---

## 📝 Data License

**CC BY-NC-SA 4.0** (Creative Commons)

This is real commercial data made publicly available by Olist on Kaggle for educational and research purposes. The data has been anonymized (customer names removed, company names in reviews replaced with Game of Thrones houses).

**Original Source:** Olist (https://olist.com/)  
**Published On:** Kaggle  
**Your Subset:** 10,000 orders from 2017 (sampled from 100K total)

---

**🚀 Let's build with REAL data!**
