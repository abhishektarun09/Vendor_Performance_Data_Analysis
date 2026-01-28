# Vendor Sales Performance Analysis
Understanding Key Drivers of Retail Performance Using Exploratory Analysis and Business Insights

This project examines retail sales, vendor performance, and inventory behavior to uncover the major factors influencing profitability and operational efficiency. The analysis focuses on identifying underperforming brands, evaluating vendor contributions, understanding cost dynamics, and assessing inventory turnover to support data‑driven decision‑making.


## Dataset
- Source: USA Open Data Portal
- Tables (no. of records):
    - sales (12.8M) 
    - begin_inventory (206K)
    - end_inventory (224K)
    - purchases (2.3M)
    - purchase_prices (12K)
    - vendor_invoice (5K)
- Time period: 2024- 2025
- Key features:
  - purchase price
  - sales price
  - freight cost
  - vendors
  - brands and products in inventory

- Created sales summary table by joining multiple tables
- Removed sales with missing prices
- Converted volume from string to numeric
- Created new features such as Gross Profit, Stock Turnover, Profit Margin etc.

## Business Problem
- Identify underperforming brands that require promotional or pricing adjustments.
- Determine top vendors contributing to sales and gross profit.
- Analyze the impact of bulk purchasing on unit costs.
- Assess inventory turnover to reduce holding costs and improve efficiency.
- Investigate using hypothesis testing the profitability variance between high-performing and low-performing brands.

## Key Insights
- Total Purchase Contribution of the top 10 vendors is 65.69% suggesting overdependence on top vendors.
- Bulk buying is ~72% cheaper than small orders for unit cost.
- Total $ 2.71M capital locked in unsold inventory.
- Low-revenue vendors maintain higher profit margins than high-revenue vendors, potentially due to premium pricing or lower operational costs.
- There is a significant difference in the mean profit margins of top-performing and low-performing vendors.

## Power BI Dashboard
![Dashboard](resources/dashboard.png)

## Data Architecture (BigQuery + dbt)

This project follows a medallion architecture implemented in BigQuery and orchestrated using dbt.

🥉 Bronze (Raw)

🥈 Silver (Cleaned & Enriched)

🥇 Gold (Analytics / Fact Tables)


## Feature Engineering

- Created consolidated sales summary by joining purchases, sales, pricing, and freight data on BigQuery using dbt

- Removed records with missing or invalid prices

- Converted volume from string to numeric

- Engineered business KPIs:

  - Gross Profit

  - Profit Margin

  - Stock Turnover

  - Sales-to-Purchase Ratio

## Data Quality & Testing (dbt)

Data quality is enforced using dbt tests, including both schema tests and custom SQL tests.

### Schema Tests

- `not_null` checks on primary identifiers

- Non-negative constraints on quantity and dollar values

- Conditional tests allowing NULLs where data may be unavailable

### Business Logic Tests

- Gross profit consistency:

  - `GrossProfit = TotalSalesDollars − TotalPurchaseDollars`

- Sanity checks on ratios:

  - Profit margins within realistic bounds

  - No negative stock turnover

## Tools & Technologies

- **Data Warehouse**: BigQuery

- **Transformation & Modeling**: dbt

- **SQL Dialect**: BigQuery SQL

- **Python**: pandas

- **Visualization**: matplotlib, Power BI

- **Environment**: Modular Python scripts, Jupyter Notebook

## How to Run
1. Clone the repo: `git clone https://github.com/abhishektarun09/Vendor_Performance_Data_Analysis.git`
2. Install dependencies: `pip install -r requirements.txt`
3. Set up new virtual environment.
4. Set up environment variables in `.env`
5. Run dbt models `dbt run`
6. Explore insights in `src/notebooks/3_Vendor_Performance_Analysis`.

## Contact
- **Author:** Abhishek Tarun 
- **Email:** [abhishek.tarun09@gmail.com](mailto:abhishek.tarun09@gmail.com)