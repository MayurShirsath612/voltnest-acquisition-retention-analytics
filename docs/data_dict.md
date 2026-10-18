# VoltNest — Data Dictionary

## Overview

This document describes the tables and columns used in the VoltNest Acquisition-to-Retention Analytics project. The project uses synthetic data for a fictional electronics retailer.

## 1. Campaigns

**Purpose:** Stores campaign details and cost-tracking availability.

| Column                    | Data Type | Description                                           |
| ------------------------- | --------- | ----------------------------------------------------- |
| `campaign_id`             | VARCHAR   | Unique campaign identifier                            |
| `campaign_name`           | VARCHAR   | Campaign name                                         |
| `channel`                 | VARCHAR   | Marketing or acquisition channel                      |
| `campaign_type`           | VARCHAR   | Campaign classification                               |
| `cost_tracking_available` | BIT       | Indicates whether campaign cost tracking is available |

## 2. Customers

**Purpose:** Stores customer identifiers and region information.

| Column            | Data Type | Description                                     |
| ----------------- | --------- | ----------------------------------------------- |
| `customer_id`     | VARCHAR   | Customer identifier                             |
| `visitor_id`      | VARCHAR   | Visitor identifier associated with the customer |
| `customer_region` | VARCHAR   | Region associated with the customer             |

## 3. Customer Summary

**Purpose:** Contains customer-level purchase history and acquisition information.

| Column                 | Data Type | Description                                         |
| ---------------------- | --------- | --------------------------------------------------- |
| `customer_id`          | VARCHAR   | Customer identifier                                 |
| `first_purchase_date`  | DATE      | First purchase date                                 |
| `total_orders`         | BIGINT    | Total orders placed by the customer                 |
| `total_revenue`        | FLOAT     | Total revenue recorded for the customer             |
| `repeat_customer`      | BIT       | Indicates whether the customer is a repeat customer |
| `first_order_date`     | DATE      | First order date                                    |
| `second_order_date`    | DATE      | Second order date, when available                   |
| `days_to_second_order` | FLOAT     | Days between the first and second orders            |
| `campaign_id`          | VARCHAR   | Attributed campaign identifier                      |
| `campaign_name`        | VARCHAR   | Attributed campaign name                            |
| `channel`              | VARCHAR   | Attributed acquisition channel                      |

## 4. Marketing Spend

**Purpose:** Stores marketing spend and advertising performance metrics.

| Column         | Data Type | Description                                |
| -------------- | --------- | ------------------------------------------ |
| `spend_date`   | DATE      | Date of the marketing spend record         |
| `campaign_id`  | VARCHAR   | Associated campaign identifier             |
| `impressions`  | BIGINT    | Number of ad impressions                   |
| `clicks`       | BIGINT    | Number of ad clicks                        |
| `spend_amount` | FLOAT     | Recorded marketing spend                   |
| `spend_month`  | VARCHAR   | Month associated with the spend record     |
| `ctr`          | FLOAT     | Click-through rate recorded in the dataset |
| `cpc`          | FLOAT     | Cost per click recorded in the dataset     |

## 5. Orders

**Purpose:** Stores order details and revenue adjustments.

| Column            | Data Type | Description                                 |
| ----------------- | --------- | ------------------------------------------- |
| `order_id`        | VARCHAR   | Order identifier                            |
| `customer_id`     | VARCHAR   | Customer who placed the order               |
| `session_id`      | VARCHAR   | Website session associated with the order   |
| `order_ts`        | DATETIME2 | Order timestamp                             |
| `gross_revenue`   | FLOAT     | Gross revenue recorded for the order        |
| `discount_amount` | FLOAT     | Discount amount                             |
| `refund_amount`   | FLOAT     | Refund amount                               |
| `order_date`      | DATE      | Order date                                  |
| `order_month`     | VARCHAR   | Month associated with the order             |
| `net_revenue`     | FLOAT     | Net revenue recorded for the order          |
| `discount_pct`    | FLOAT     | Discount percentage recorded in the dataset |

## 6. Regions

**Purpose:** Provides region lookup information.

| Column        | Data Type | Description       |
| ------------- | --------- | ----------------- |
| `region_id`   | INT       | Region identifier |
| `region_name` | NVARCHAR  | Region name       |

## 7. Website Events

**Purpose:** Records individual website events associated with sessions.

| Column       | Data Type | Description                                  |
| ------------ | --------- | -------------------------------------------- |
| `event_id`   | VARCHAR   | Website event identifier                     |
| `session_id` | VARCHAR   | Session in which the event occurred          |
| `event_ts`   | DATETIME2 | Event timestamp                              |
| `event_type` | VARCHAR   | Type of website event                        |
| `order_id`   | VARCHAR   | Associated order identifier, when applicable |
| `event_date` | DATE      | Event date                                   |

An `order_id` may be missing for events that are not associated with a purchase.

## 8. Website Sessions

**Purpose:** Stores session-level acquisition information and conversion-funnel indicators.

| Column             | Data Type | Description                                      |
| ------------------ | --------- | ------------------------------------------------ |
| `session_id`       | VARCHAR   | Website session identifier                       |
| `visitor_id`       | VARCHAR   | Visitor associated with the session              |
| `session_start_ts` | DATETIME2 | Session start timestamp                          |
| `session_end_ts`   | DATETIME2 | Session end timestamp                            |
| `campaign_id`      | VARCHAR   | Campaign associated with the session             |
| `device_type`      | VARCHAR   | Device category used during the session          |
| `landing_page`     | VARCHAR   | Landing page associated with the session         |
| `session_date`     | DATE      | Session date                                     |
| `session_month`    | VARCHAR   | Month associated with the session                |
| `converted`        | BIT       | Session conversion indicator                     |
| `product_view`     | BIT       | Indicates whether a product was viewed           |
| `add_to_cart`      | BIT       | Indicates whether an add-to-cart action occurred |
| `checkout_started` | BIT       | Indicates whether checkout was started           |
| `purchase`         | BIT       | Indicates whether a purchase occurred            |

## Relationships

The following relationships were used or discussed in the Power BI model:

- `campaigns[campaign_id]` → `website_sessions[campaign_id]`
- `campaigns[campaign_id]` → `marketing_spend[campaign_id]`
- `website_sessions[session_id]` → `orders[session_id]`
- `customers[customer_id]` → `orders[customer_id]`
- `website_sessions[session_id]` → `website_events[session_id]`
- `customer_summary[customer_id]` ↔ `customers[customer_id]`

The relationship between `customer_summary` and `customers` was configured as an active one-to-one relationship. The relationship status of other tables should be confirmed in the current Power BI model.

## Data Notes

- The data is synthetic and represents a fictional business.
- Date and timestamp columns were converted to `DATE` or `DATETIME2` in SQL Server.
- Most columns allow NULL values according to the SQL Server metadata.
- Missing marketing spend should not automatically be interpreted as zero spend.
- `FLOAT` columns are the existing SQL data types for revenue and marketing metrics; they have not been changed to `DECIMAL` as part of this documentation.
