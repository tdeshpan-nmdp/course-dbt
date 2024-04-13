{{
  config(
    materialized='table'
  )
}}

WITH EVENT_TYPE_COUNTS AS (
    SELECT 
        COUNT(DISTINCT CASE WHEN EVENT_TYPE = 'page_view' THEN SESSION_ID END) AS page_view_count,
        COUNT(DISTINCT CASE WHEN EVENT_TYPE = 'add_to_cart' THEN SESSION_ID END) AS add_to_cart_count,
        COUNT(DISTINCT CASE WHEN EVENT_TYPE = 'checkout' THEN SESSION_ID END) AS checkout_count
    FROM 
        {{ ref('stg_postgres__events') }}
)

SELECT 
    page_view_count,
    add_to_cart_count,
    checkout_count,
    -- Drop-off rates between each step in the product funnel
    ROUND((1 - (add_to_cart_count / page_view_count)) * 100, 2) AS drop_off_prcntg_page_view_to_cart,
    ROUND((1 - (checkout_count / add_to_cart_count)) * 100, 2) AS drop_off_prcntg_cart_to_checkout
FROM 
    EVENT_TYPE_COUNTS;