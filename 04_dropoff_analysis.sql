-- DROP-OFF ANALYSIS
-- Number of users lost between each
-- consecutive funnel stage


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

    COUNTIF(viewed = 1)       - COUNTIF(viewed_item = 1)  AS users_lost_after_page_view,
    COUNTIF(viewed_item = 1)  - COUNTIF(added_to_cart = 1) AS users_lost_after_product_view,
    COUNTIF(added_to_cart = 1) - COUNTIF(checkout = 1)     AS users_lost_after_cart,
    COUNTIF(checkout = 1)     - COUNTIF(purchased = 1)     AS users_lost_after_checkout

FROM funnel_base;
