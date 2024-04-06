{{
  config(
    materialized='table'
  )
}}

with
events as (
    select 
    EVENT_ID, 
    SESSION_ID, 
    USER_ID, 
    PAGE_URL, 
    CREATED_AT, 
    EVENT_TYPE, 
    ORDER_ID, 
    PRODUCT_ID
    from {{ ref('stg_postgres__events') }}
),
products as (
    select distinct
    PRODUCT_ID,
    NAME
    from {{ref('stg_postgres__products')}}
),
page_views as (
    select
        events.EVENT_ID, 
        events.SESSION_ID, 
        events.USER_ID, 
        events.PAGE_URL, 
        events.CREATED_AT, 
        events.EVENT_TYPE, 
        events.ORDER_ID, 
        products.NAME,
        products.PRODUCT_ID
    from events
    join products on events.PRODUCT_ID = products.PRODUCT_ID
    where event_type = 'page_view'
)

select * from page_views