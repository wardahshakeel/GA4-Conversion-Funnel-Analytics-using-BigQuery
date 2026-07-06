-- EVENT summariy
-- count total occurrences of each event

SELECT
    event_name,
    COUNT(*) AS total_events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
GROUP BY event_name
ORDER BY total_events DESC;
