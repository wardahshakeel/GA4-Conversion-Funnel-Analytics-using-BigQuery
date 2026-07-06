-- USER FUNNEL
-- one row peruser, flagging which funnel
-- stages each user reached

WITH funnel_base AS (

    SELECT
        user_pseudo_id,
        MAX(CASE WHEN event_name = 'page_view'      THEN 1 ELSE 0 END) AS viewed,
        MAX(CASE WHEN event_name = 'view_item'      THEN 1 ELSE 0 END) AS viewed_item,
        MAX(CASE WHEN event_name = 'add_to_cart'    THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS began_checkout,
        MAX(CASE WHEN event_name = 'purchase'       THEN 1 ELSE 0 END) AS purchased

    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE event_name IN (
        'page_view',
        'view_item',
        'add_to_cart',
        'begin_checkout',
        'purchase'
    )
    GROUP BY user_pseudo_id

),

funnel_stages AS (

    SELECT 'Page View'      AS stage, 1 AS stage_order, SUM(viewed)         AS users FROM funnel_base
    UNION ALL
    SELECT 'View Item',     2,        SUM(viewed_item)                              FROM funnel_base
    UNION ALL
    SELECT 'Add to Cart',   3,        SUM(added_to_cart)                            FROM funnel_base
    UNION ALL
    SELECT 'Begin Checkout',4,        SUM(began_checkout)                           FROM funnel_base
    UNION ALL
    SELECT 'Purchase',      5,        SUM(purchased)                                FROM funnel_base

)

SELECT *
FROM funnel_stages
ORDER BY stage_order;
