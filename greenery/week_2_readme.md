# Week 2

## What is our user repeat rate?
79.84%
```sql
WITH UserPurchaseCounts AS (
    SELECT
        USER_ID,
        COUNT(DISTINCT ORDER_ID) AS PurchaseCount
    FROM
        stg_postgres__orders
    GROUP BY
        USER_ID
),
RepeatUsers AS (
    SELECT
        COUNT(*) AS RepeatUserCount
    FROM
        UserPurchaseCounts
    WHERE
        PurchaseCount >= 2
),
TotalUsers AS (
    SELECT
        COUNT(DISTINCT USER_ID) AS TotalUserCount
    FROM
        stg_postgres__orders
)
SELECT
    (RepeatUserCount::FLOAT / TotalUserCount)*100 AS RepeatRate
FROM
    RepeatUsers, TotalUsers;
```

## What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Likely purchase again:
- Viewed the page at a certain interval in the past week; could be a good indicator that the user will likely purchase again
- If there is a promo running for a product, and the user had bought this product in the past, they might buy it again

Likely NOT to purchase again:
- There are low chances the user would purchase a product if they have spent less time browsing on the product page
- Low page views in general on the app

This might help:
- Product reviews
- Normalized rate of product return by a user over a median

## 