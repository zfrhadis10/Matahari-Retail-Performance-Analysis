# 🛒 End-to-End Retail Data Pipeline: Matahari E-Commerce Web Scraping & BI Analytics

## 🌟 Project Overview

This project demonstrates a comprehensive data engineering lifecycle: from **Automated Web Scraping** on [Matahari.com](http://Matahari.com) to a fully **Normalized PostgreSQL Database** and an **Interactive Power BI Dashboard**.

The goal was to build a robust ETL pipeline that transforms raw, unstructured web data into structured business intelligence to analyze retail pricing strategies, brand dominance, and discount efficiency.

---

## 🛠️ Toolstack & Skills

* **Extraction:** Python (Selenium, BeautifulSoup) for automated web data acquisition.
* **Transformation:** Pandas for data cleaning, regex-based formatting, and type casting.
* **Data Modeling:** PostgreSQL (3NF Normalization, DDL/DML) for relational database architecture.
* **Analytics:** Advanced SQL (CTEs, Joins, Case Statements) for deep-dive EDA.
* **Visualization:** Power BI for executive-level dashboarding.

---

## ⚙️ Data Engineering Workflow (ETL)

### 1. Extract (Web Scraping)

* **Script:** `Web Scrapping and Data Preparation.ipynb`
* **Process:** Used Selenium to navigate [Matahari.com](http://Matahari.com) and extracted over 80+ product records.
* **Captured Data:** Product IDs, Brand names, Product descriptions, Discounts, and Prices.

### 2. Transform (Data Pre-processing)

* **Cleaning:** Removed currency symbols (Rp) and percentage signs (%) using Python.
* **Data Integrity:** Ensured numeric columns were correctly typed for database compatibility.
* **Output:** Generated `Dataset Clean.csv` for the loading phase.

### 3. Load & Data Modeling (The Core)

* **Script:** `EDA.sql`
* **Staging Layer:** Ingested raw CSV data into a temporary `staging` table using the `COPY` command.
* **Database Normalization (3NF):** To ensure data integrity and reduce redundancy, I re-architected the flat-file into three relational tables:
  * `brands`: Unique brand entities with auto-incrementing IDs.
  * `product`: Linked to brands via Foreign Keys.
  * `discounts`: Detailed pricing and promotional data linked to specific products.

---

## 📊 Advanced SQL Analytics & Insights

I utilized the normalized database to run complex analytical queries:

* **Brand Pricing Integrity:** Calculated the "Price Gap" between the cheapest and priciest products per brand.
* **Discount Efficiency:** Identified "High-Value Offers" and analyzed brand reliance on discounts >30%.
* **Market Share Analysis:** Used **CTEs (Common Table Expressions)** to calculate the percentage of product variety dominance across the catalog.
* **Inventory Segmentation:** Categorized products into 'Premium', 'Mid-Range', and 'Budget' segments using `CASE` logic.

---

## 📈 Business Intelligence Dashboard

The `Dashboard.pbix` file provides an interactive view of the processed data:

* **KPI Scorecards:** Total Revenue, Total Brands, and Overall Average Discount.
* **Market Dominance:** Visual representation of brand product variety.
* **Price Tiering:** Analysis of product distribution across different price segments.

### 📸 Dashboard Preview

<div align="center">
  <img src="https://raw.githubusercontent.com/zfrhadis10/Matahari-Retail-Performance-Analysis/main/Visual/Overview.png" width="80%" alt="Dashboard Overview">
  <br><br>
  <img src="https://raw.githubusercontent.com/zfrhadis10/Matahari-Retail-Performance-Analysis/main/Visual/Categories.png" width="80%" alt="Dashboard Categories">
</div>

---

## 📂 Project Structure

* `Web Scrapping and Data Preparation.ipynb`: Python ETL logic.
* `EDA.sql`: SQL Schema, Normalization logic, and Analytical queries.
* `Dataset Clean.csv`: The final processed dataset ready for SQL ingestion.
* `Dashboard.pbix`: Interactive Power BI dashboard.
* `Dataset From Web Scrapping.csv`: Raw data extracted from the source.
