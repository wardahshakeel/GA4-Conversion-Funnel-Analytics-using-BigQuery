-- CONVERSION RATES
-- step bysteo and overall funnel conversion


WITH funnel_base AS (

    SELECT
        user_pseudo_id,
        MAX(CASE WHEN event_name = 'page_view'      THEN 1 ELSE 0 END) AS viewed,
        MAX(CASE WHEN event_name = 'view_item'      THEN 1 ELSE 0 END) AS viewed_item,
        MAX(CASE WHEN event_name = 'add_to_cart'    THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS checkout,
        MAX(CASE WHEN event_name = 'purchase'       THEN 1 ELSE 0 END) AS purchased

    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    GROUP BY user_pseudo_id

)

SELECT

    COUNTIF(viewed = 1)       AS page_views,
    COUNTIF(viewed_item = 1)  AS product_views,
    COUNTIF(added_to_cart = 1) AS carts,
    COUNTIF(checkout = 1)     AS checkouts,
    COUNTIF(purchased = 1)    AS purchases,

    ROUND(100 * COUNTIF(viewed_item = 1)  / COUNTIF(viewed = 1), 2)       AS page_to_product_conversion,
    ROUND(100 * COUNTIF(added_to_cart = 1) / COUNTIF(viewed_item = 1), 2) AS product_to_cart_conversion,
    ROUND(100 * COUNTIF(checkout = 1)      / COUNTIF(added_to_cart = 1), 2) AS cart_to_checkout_conversion,
    ROUND(100 * COUNTIF(purchased = 1)     / COUNTIF(checkout = 1), 2)    AS checkout_to_purchase_conversion,
    ROUND(100 * COUNTIF(purchased = 1)     / COUNTIF(viewed = 1), 2)      AS overall_conversion_rate

FROM funnel_base;
