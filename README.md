# GA4 E-Commerce Funnel Analysis (BigQuery / GoogleSQL)

A SQL-based analysis of the public **Google Analytics 4 (GA4) obfuscated sample e-commerce dataset**, built in BigQuery. The project reconstructs the customer purchase funnel — from page view through purchase — using raw GA4 event-level data, and quantifies conversion and drop-off at each stage.

## Project overview

GA4 exports event-level data (one row per event), not pre-aggregated funnels. This project shows how to go from raw events to a business-ready funnel report using:

- **CTEs (Common Table Expressions)** to stage transformations logically
- **Conditional aggregation** (`MAX(CASE WHEN ...)`) to pivot per-user event flags from long-format event data
- **`COUNTIF`** for clean conversion-rate arithmetic
- **`UNION ALL`** to reshape wide per-user flags into a tidy long-format funnel table for visualization

## Dataset

[`bigquery-public-data.ga4_obfuscated_sample_ecommerce`](https://console.cloud.google.com/bigquery?p=bigquery-public-data&d=ga4_obfuscated_sample_ecommerce) — a public BigQuery dataset of obfuscated GA4 event data from the Google Merchandise Store.

## Funnel stages analyzed

1. Page View
2. View Item
3. Add to Cart
4. Begin Checkout
5. Purchase

## Files

| File | Description |
|---|---|
| `01_event_summary.sql` | Total count of each event type in the dataset — a sanity check on volume and event naming before building the funnel. |
| `02_user_funnel.sql` | Builds a one-row-per-user funnel flag table via CTEs, then reshapes it into a long-format table of user counts per funnel stage. |
| `03_conversion_rates.sql` | Calculates step-by-step conversion rates (e.g. product view → cart) and overall conversion rate from page view to purchase. |
| `04_dropoff_analysis.sql` | Quantifies the number of users lost between each consecutive funnel stage, highlighting the biggest leak points. |

## How to run

1. Open [BigQuery Console](https://console.cloud.google.com/bigquery) (or use `bq query` from the CLI).
2. Make sure you have access to public datasets (no setup needed — `bigquery-public-data` is publicly queryable).
3. Run the `.sql` files in order (01 → 04). Each is self-contained and can also be run independently.

```bash
bq query --use_legacy_sql=false < 02_user_funnel.sql
```

## Example insight

Running `04_dropoff_analysis.sql` shows exactly where the biggest user drop-off occurs in the funnel — typically the largest single loss is between **Add to Cart** and **Begin Checkout**, a common friction point in e-commerce (often due to shipping cost surprises, forced account creation, or an overly long checkout flow).

## Tech stack

- **BigQuery / GoogleSQL**
- Public GA4 sample dataset

## Author

Wardah — data science student


