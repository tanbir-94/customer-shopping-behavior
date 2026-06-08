# 🛍️ Customer Shopping Behavior — End-to-End Data Analysis Project

> A complete data analysis project covering data cleaning, exploratory analysis, SQL business queries, and an interactive Power BI dashboard — built to demonstrate real-world skills for Data Analyst and MIS Executive roles.

---

## 📌 Project Overview

This project analyzes the shopping behavior of **3,900 customers** across 25 products, 50 US states, and 4 seasons. The goal was to uncover actionable business insights around revenue, customer segmentation, product performance, and subscription behavior.

---

## 🗂️ Project Structure

```
customer-shopping-behavior/
│
├── data/
│   └── customer_shopping_behavior.csv       # Raw dataset
│
├── notebooks/
│   └── customer_behavior.ipynb              # Python EDA & cleaning notebook
│
├── sql/
│   └── customer_behavior_analysis.sql       # 13 business SQL queries
│
├── dashboard/
│   └── customer_behavior_dashboard.pbix     # Power BI dashboard
│
└── README.md
```

---

## 🔧 Tools & Technologies

| Tool | Purpose |
|---|---|
| Python (Pandas, Matplotlib, Seaborn) | Data cleaning, EDA, visualization |
| PostgreSQL + pgAdmin | Data storage & SQL analysis |
| Power BI Desktop | Interactive dashboard |
| Jupyter Notebook | Analysis documentation |

---

## 📊 Phase 1 — Data Cleaning (Python)

**Dataset:** 3,900 rows × 18 columns

Key steps performed:
- Handled missing values in `Review Rating` using **group-wise median imputation** by Category
- Standardized all column names to `snake_case`
- Created `age_group` feature using `pd.qcut()` (quantile-based binning)
- Mapped `Frequency of Purchases` to numeric `purchase_frequency_days`
- Identified and dropped redundant column (`Promo Code Used` = duplicate of `Discount Applied`)
- Exported cleaned data to PostgreSQL using SQLAlchemy

---

## 📈 Phase 2 — Exploratory Data Analysis (Python)

9 charts generated covering:

- Purchase Amount Distribution
- Top 10 Items by Revenue
- Revenue by Category
- Age Group vs Avg Purchase Amount
- Gender vs Purchase Amount (Boxplot)
- Season-wise Revenue
- Payment Method Distribution
- Subscriber vs Non-Subscriber Avg Purchase
- Discount Impact on Revenue
- Correlation Heatmap

---

## 🗄️ Phase 3 — SQL Business Analysis (PostgreSQL)

13 queries organized across 4 sections:

**Section 1 — Business Overview**
- Dataset snapshot (revenue, customers, rating, coverage)
- Gender revenue with % share using `SUM() OVER()`
- Top 5 states by revenue

**Section 2 — Product & Category**
- Category performance scorecard
- Top 3 products per category using `RANK() OVER (PARTITION BY)`
- Discount impact on revenue and ratings

**Section 3 — Customer Segmentation**
- RFM-style segmentation (New / Returning / High-Value Loyal / Loyal)
- Age group revenue + subscription rate

**Section 4 — Advanced Insights**
- Running total revenue by season (window function)
- Shipping type vs customer satisfaction
- High spenders who don't subscribe (business opportunity query)
- Payment method preference by age group
- Season × Category revenue matrix (manual PIVOT)

---

## 📊 Phase 4 — Power BI Dashboard

**Single-page interactive dashboard featuring:**

- KPI Cards: Total Revenue (233K), Customers (3,900), Avg Purchase ($59.76), Avg Rating (3.75)
- Slicers: Subscription Status, Gender, Category, Season, Shipping Type
- Revenue by Season (bar chart)
- Revenue by Category & Season (grouped bar)
- Subscription Status split (donut)
- Shipping Type vs Avg Rating (horizontal bar)
- Payment Method Distribution (donut)
- Gender Revenue split (top-right visual)

---

## 💡 Key Business Insights

1. **Clothing dominates revenue** — $104K out of $233K total (44.7%)
2. **Male customers contribute 67.7%** of total revenue vs 32.3% female
3. **Fall is the strongest season** — $60,018 in revenue
4. **73% of customers are non-subscribers** — significant upsell opportunity
5. **Discount does not reduce avg spend** — customers with discounts spend similarly to those without
6. **All shipping types have nearly equal ratings (~3.7–3.8)** — no significant satisfaction gap
7. **Payment methods are evenly distributed** across 6 methods — no single dominant preference

---

## 🚀 How to Run

**Python Notebook:**
```bash
pip install pandas matplotlib seaborn sqlalchemy psycopg2-binary
jupyter notebook notebooks/customer_behavior.ipynb
```

**SQL Queries:**
- Import `data/customer_shopping_behavior.csv` into PostgreSQL as table `customer`
- Run `sql/customer_behavior_analysis.sql` in pgAdmin

**Power BI:**
- Open `dashboard/customer_behavior_dashboard.pbix` in Power BI Desktop

---

## 👤 About

This project was built as part of my data analytics portfolio. I am a fresher actively looking for opportunities in **Data Analyst** and **MIS Executive** roles.

**Skills demonstrated:** Python · SQL · Power BI · Data Cleaning · EDA · Business Insights · Dashboard Design

---

*Dataset source: Kaggle — Customer Shopping Behavior Dataset*
