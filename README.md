# VoltNest — Acquisition-to-Retention Analytics

### End-to-End Data Analytics Project | Python • SQL Server • Power BI

An end-to-end data analytics project focused on understanding the customer journey from acquisition to purchase and retention for **VoltNest**, a fictional mid-range electronics retailer. Using synthetic data, the project combines Python-based data understanding and exploratory analysis, SQL Server business analysis, and an interactive three-page Power BI report.

The goal is to understand which acquisition channels attract customers, how effectively website sessions convert into purchases, how marketing spend relates to revenue, and how discounts, refunds, and repeat purchasing affect business performance.

---

## Project Overview

VoltNest wants to understand how effectively it acquires customers and converts them into repeat buyers. This project explores the following business questions:

- Which acquisition channels generate the most customers and revenue?
- Which marketing campaigns deliver the strongest return relative to advertising spend?
- Where do customers drop off in the website conversion funnel?
- How does purchase conversion vary across devices?
- How do discounts and refunds affect net revenue?
- What proportion of customers make repeat purchases?
- How does customer retention vary by acquisition channel?
- How long do repeat customers take to place their second order?

The analysis follows a workflow of **data understanding → data validation and cleaning → exploratory analysis → SQL business analysis → Power BI reporting**.

---

## Quick Stats

| Metric | Value |
|---|---:|
| Website Sessions | 45,000 |
| Customers | 3,302 |
| Orders | 4,278 |
| Gross Revenue | 557,586.18 |
| Discounts | 20,696.24 |
| Refunds | 7,906.76 |
| Net Revenue | 528,983.18 |
| Average Order Value | 123.65 |
| Session-to-Purchase Rate | 9.51% |
| Repeat Customer Rate | 23.59% |

*Revenue and order values are expressed in the dataset's currency units. The currency denomination has not been independently established.*

---

## Dataset

The project uses an entirely **synthetic dataset** created to represent a fictional electronics e-commerce business. It contains related marketing, customer, website activity, and order data.

### Data Tables

| Table | Rows | Description |
|---|---:|---|
| `campaigns` | 19 | Campaign details, channels, campaign types, and cost-tracking availability |
| `customers` | 3,302 | Customer identifiers, visitor identifiers, and customer regions |
| `customer_summary` | 3,302 | Customer-level purchase history, revenue, repeat-purchase status, and acquisition information |
| `marketing_spend` | 6,552 | Marketing impressions, clicks, spend, CTR, CPC, and campaign dates |
| `orders` | 4,278 | Order timestamps, gross revenue, discounts, refunds, and net revenue |
| `website_events` | 144,097 | Website event activity, including event types and associated orders where applicable |
| `website_sessions` | 45,000 | Website sessions, acquisition campaigns, devices, landing pages, and conversion-funnel indicators |

The raw dataset contains six CSV tables. The processed dataset contains seven CSV tables, including the customer-level summary.

### Data Validation

The following checks were completed during data preparation:

- Checked primary-key uniqueness across the tables.
- Validated five foreign-key relationships; all five checks returned zero invalid references.
- Checked date conversion across the main date fields; no invalid dates were found.
- Examined missing values and their meaning, including missing `order_id` values in website events where an order was not associated with the event.
- Converted relevant date columns to date/datetime types during preparation.

The source data is synthetic, and the analysis should be interpreted as a portfolio demonstration rather than evidence of the performance of a real company.

---

## Tools & Technologies

| Category | Tools |
|---|---|
| Programming and analysis | Python, Pandas |
| Data exploration | Jupyter Notebook |
| Database | Microsoft SQL Server |
| BI and visualization | Power BI Desktop, DAX |
| Version control | Git and GitHub |
| Data storage | CSV files |

---

## Project Workflow

```text
Synthetic Raw CSV Data
        |
        v
Python — Data Understanding and Validation
        |
        v
Data Preparation and Processed CSV Files
        |
        v
Exploratory Data Analysis
        |
        v
SQL Server — Business Analysis
        |
        v
Power BI — Interactive Reporting
        |
        v
Business Insights and Recommendations
```

---

## Phase 1 — Python: Data Understanding and EDA

**Location:** `notebooks/`

Python and Jupyter Notebook were used to inspect the datasets, understand their structure, validate the data, and calculate customer and business metrics.

### Data Understanding and Preparation

The work included:

- Loading the raw and processed CSV files into Pandas DataFrames.
- Inspecting row counts, column names, data types, and missing values.
- Converting relevant date columns into appropriate date/datetime types.
- Checking primary keys and relationships between datasets.
- Investigating missing values in context rather than treating every missing value as an error.
- Creating customer-level purchase and retention metrics.

### Customer-Level Analysis

Customer features included:

- First purchase date
- Second purchase date
- Total orders
- Total revenue
- Repeat-customer status
- Days between the first and second purchases
- Acquisition channel and campaign information

These features support the analysis of repeat purchasing and customer retention.

### Exploratory Analysis

The exploratory analysis focused on:

- Dataset structure and data quality
- Revenue and order metrics
- Acquisition-channel performance
- Customer purchasing behavior
- Conversion-funnel performance
- Discounts and refunds
- Repeat purchasing and time to second order

---

## Phase 2 — SQL Server: Business Analysis

**Database:** `VoltNestAnalytics`  
**Schema:** `Vsch`  
**SQL script:** `sql/voltnest.sql`

SQL Server was used to query the prepared tables and investigate the project's business questions.

### Analysis Areas

| Analysis | Purpose |
|---|---|
| Acquisition channel performance | Compare customer counts, orders, revenue, and average revenue per customer |
| Campaign conversion | Identify differences in session-to-purchase conversion across campaigns |
| Marketing efficiency | Compare campaign revenue against recorded marketing spend |
| Customer acquisition cost | Compare recorded channel spend with attributed customer counts |
| Conversion funnel | Measure progression from product views to cart, checkout, and purchase |
| Revenue quality | Quantify discounts, refunds, net revenue, and average order value |
| Customer retention | Compare repeat-customer rates across channels |
| Time to second purchase | Measure the time between the first and second orders |

### Key SQL Findings

- Organic Search generated 650 customers and 113,296.36 in attributed revenue in the customer-summary analysis.
- Email campaigns delivered the strongest ROAS among the cost-tracked campaigns examined.
- Recorded acquisition spend varied considerably across paid channels, with Paid Search having a much higher calculated CAC than Email or Display.
- The conversion funnel showed substantial drop-off between product views and purchases.
- Repeat-customer behavior differed across acquisition channels.

Marketing attribution and ROAS results depend on the available campaign, session, order, and spend relationships. ROAS measures attributed revenue relative to advertising spend; it does not account for all business costs and should not be interpreted as profit.

---

## Phase 3 — Power BI Dashboard

**Location:** `powerbi/Voltnest.pbix`

The Power BI report contains three pages covering executive performance, marketing acquisition, and conversion and retention.

### Page 1 — Executive Summary

Provides an overview of business performance through KPI cards and channel-level analysis.

**KPI cards**

- Total Revenue
- Total Orders
- Total Customers
- Average Order Value
- Session-to-Purchase Rate
- Repeat Customer Rate

**Visuals**

- Monthly Revenue vs Marketing Spend
- Revenue by Acquisition Channel
- Channel Performance Summary Table
- Customers by Acquisition Channel

This page provides a high-level view of revenue, acquisition, and customer performance.

### Page 2 — Acquisition & Marketing Performance

Focuses on marketing efficiency and the relationship between campaign spend and customer acquisition.

**KPI cards**

- Total Sessions
- Total Marketing Spend
- Total Clicks
- Click-Through Rate (CTR)
- Return on Ad Spend (ROAS)
- Customer Acquisition Cost (CAC)

The page includes campaign and channel comparisons, conversion analysis, and campaign-level performance reporting.

The analysis distinguishes between campaigns with recorded marketing spend and channels without recorded spend. Missing spend is not automatically treated as zero, since the absence of a recorded cost does not prove that acquisition was free.

### Page 3 — Conversion & Customer Retention

Examines website conversion, customer retention, and revenue adjustments.

**KPI cards**

- Add-to-Cart Rate
- Checkout Completion Rate
- Repeat Customer Rate
- Discount Rate
- Refund Rate
- Average Days to Second Purchase

**Visuals**

- Website Conversion Funnel
- Purchase Conversion by Device
- Customer Retention by Channel
- Monthly Discount and Refund Rates

The funnel follows four stages:

1. Product Views
2. Add to Cart
3. Checkout
4. Purchases

This page highlights where conversion drops occur and how customer purchasing behavior varies across devices and acquisition channels.

### DAX Measures

The report uses DAX measures for calculations such as:

- Total Revenue
- Total Orders
- Total Customers
- Average Order Value
- Total Sessions
- Purchase Sessions
- Total Marketing Spend
- CTR
- Session-to-Purchase Rate
- ROAS
- CAC
- Add-to-Cart Rate
- Checkout Completion Rate
- Repeat Customer Rate
- Discount Rate
- Refund Rate
- Average Days to Second Purchase

The measures use the relationships between the underlying tables to support analysis in report visuals.

---

## Key Insights & Recommendations

### 1. Organic Search is a strong acquisition channel

Organic Search generated 650 customers and 113,296.36 in attributed revenue in the customer-summary analysis, the highest revenue among the listed acquisition channels.

**Recommendation:** Investigate which landing pages and products contribute to Organic Search performance and identify opportunities to improve organic acquisition.

### 2. Email campaigns deliver strong returns relative to recorded spend

Email campaigns performed well in the campaign-level ROAS analysis. Email Campaign 2 recorded approximately 3.18x ROAS, calculated from 39,942.24 in attributed revenue and 12,553.80 in spend.

**Recommendation:** Investigate the characteristics of high-performing Email campaigns before reallocating budget. Consider conversion quality and longer-term customer value alongside ROAS.

### 3. Paid Search has a high calculated acquisition cost

Among the paid channels with recorded spend, Paid Search had a calculated CAC of approximately 487.54, compared with 87.96 for Email and 95.70 for Display.

**Recommendation:** Review Paid Search campaign targeting, cost efficiency, and conversion performance. These CAC figures should be interpreted in light of the project's customer-attribution method.

### 4. The website funnel has substantial conversion drop-off

Of 45,000 website sessions, 18,454 reached the add-to-cart stage, 11,869 reached checkout, and 4,278 resulted in purchases. The overall session-to-purchase rate was 9.51%.

**Recommendation:** Investigate product-page engagement, cart abandonment, checkout usability, and the reasons visitors do not complete purchases.

### 5. Repeat purchasing represents an opportunity for retention analysis

Of 3,302 customers, 779 were repeat customers, giving a repeat-customer rate of 23.59%. Repeat customers took an average of approximately 191.5 days to place their second order.

**Recommendation:** Investigate repeat-purchase timing and customer segments to identify opportunities for relevant follow-up campaigns and retention initiatives.

### 6. Discounts and refunds affect realized revenue

The dataset records 20,696.24 in discounts and 7,906.76 in refunds. Net revenue was 528,983.18, compared with gross revenue of 557,586.18.

**Recommendation:** Monitor discount and refund trends over time, and investigate the products, campaigns, or customer journeys associated with unusually high rates.

*These recommendations are hypotheses for further business investigation, not claims that a specific intervention has already produced results.*

---

## Repository Structure

```text
acquisition-to-retention-analytics/
│
├── data/
│   ├── raw/
│   │   ├── campaigns.csv
│   │   ├── customers.csv
│   │   ├── marketing_spend.csv
│   │   ├── orders.csv
│   │   ├── website_events.csv
│   │   └── website_sessions.csv
│   │
│   └── processed/
│       ├── campaigns.csv
│       ├── customer_summary.csv
│       ├── customers.csv
│       ├── marketing_spend.csv
│       ├── orders.csv
│       ├── website_events.csv
│       └── website_sessions.csv
│
├── notebooks/
│   ├── EDA.ipynb
│   ├── data_understanding.ipynb
│   └── Untitled.ipynb
│
├── powerbi/
│   └── Voltnest.pbix
│
├── sql/
│   └── voltnest.sql
│
├── src/
│   └── generate_data.ipynb
│
├── .gitignore
└── README.md
```

---

## How to Explore the Project

1. **Python:** Open the notebooks in `notebooks/` to review data understanding and exploratory analysis.
2. **SQL Server:** Use the SQL script in `sql/` to inspect the business-analysis queries. The project database and tables must be available in your SQL Server environment.
3. **Power BI:** Open `powerbi/Voltnest.pbix` in Power BI Desktop to explore the three report pages.
4. **Data:** Review the CSV files under `data/raw/` and `data/processed/` to understand the source and prepared datasets.

The data is synthetic, so the project can be used to demonstrate analytics techniques without representing the confidential performance of a real business.

---

## Conclusion

VoltNest — Acquisition-to-Retention Analytics demonstrates an end-to-end analytics workflow across Python, SQL Server, and Power BI. It connects acquisition and marketing performance with website conversion, revenue adjustments, and customer retention.

The project emphasizes data validation, business-focused analysis, metric definition, and communicating findings through interactive reporting.

**Technologies:** Python • Pandas • Jupyter Notebook • SQL Server • Power BI • DAX • Git • GitHub
