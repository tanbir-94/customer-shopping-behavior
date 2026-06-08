-- ============================================================
-- PROJECT   : Customer Shopping Behavior Analysis
-- DATABASE  : customer_behavior
-- TABLE     : customer
-- AUTHOR    : Md Tanbir Rja
-- TOOL      : PostgreSQL + pgAdmin
-- ============================================================

-- ============================================================
-- SECTION 1 : BASIC BUSINESS OVERVIEW
-- ============================================================

-- Q1: Dataset Snapshot — Total customers, avg spend, avg rating
SELECT 
    COUNT(DISTINCT customer_id)                     AS total_customers,
    ROUND(AVG(purchase_amount)::NUMERIC, 2)         AS avg_spend,
    ROUND(AVG(review_rating)::NUMERIC, 2)           AS avg_rating,
    COUNT(DISTINCT item_purchased)                  AS unique_products,
    COUNT(DISTINCT location)                        AS states_covered
FROM customer;


-- Q2: Revenue by Gender with Percentage Share
SELECT 
    gender,
    COUNT(customer_id)                              AS total_orders,
    ROUND(SUM(purchase_amount)::NUMERIC, 2)         AS total_revenue,
    ROUND(
        100.0 * SUM(purchase_amount) / SUM(SUM(purchase_amount)) OVER(),
    2)                                              AS revenue_pct
FROM customer
GROUP BY gender
ORDER BY total_revenue DESC;


-- Q3: Top 5 States by Revenue
SELECT 
    location,
    COUNT(customer_id)                              AS orders,
    ROUND(SUM(purchase_amount)::NUMERIC, 2)         AS total_revenue,
    ROUND(AVG(purchase_amount)::NUMERIC, 2)         AS avg_order_value
FROM customer
GROUP BY location
ORDER BY total_revenue DESC
LIMIT 5;


-- ============================================================
-- SECTION 2 : PRODUCT & CATEGORY ANALYSIS
-- ============================================================

-- Q4: Category Performance Scorecard
SELECT 
    category,
    COUNT(*)                                        AS total_orders,
    ROUND(SUM(purchase_amount)::NUMERIC, 2)         AS total_revenue,
    ROUND(AVG(purchase_amount)::NUMERIC, 2)         AS avg_order_value,
    ROUND(AVG(review_rating)::NUMERIC, 2)           AS avg_rating
FROM customer
GROUP BY category
ORDER BY total_revenue DESC;


-- Q5: Top 3 Products Per Category (Window Function — RANK)
WITH product_rank AS (
    SELECT 
        category,
        item_purchased,
        COUNT(*)                                    AS total_orders,
        ROUND(SUM(purchase_amount)::NUMERIC, 2)     AS total_revenue,
        RANK() OVER (
            PARTITION BY category 
            ORDER BY COUNT(*) DESC
        )                                           AS rnk
    FROM customer
    GROUP BY category, item_purchased
)
SELECT category, rnk, item_purchased, total_orders, total_revenue
FROM product_rank
WHERE rnk <= 3
ORDER BY category, rnk;


-- Q6: Discount Impact on Revenue and Ratings
SELECT 
    discount_applied,
    COUNT(*)                                        AS total_orders,
    ROUND(AVG(purchase_amount)::NUMERIC, 2)         AS avg_spend,
    ROUND(SUM(purchase_amount)::NUMERIC, 2)         AS total_revenue,
    ROUND(AVG(review_rating)::NUMERIC, 2)           AS avg_rating
FROM customer
GROUP BY discount_applied;


-- ============================================================
-- SECTION 3 : CUSTOMER SEGMENTATION
-- ============================================================

-- Q7: RFM-style Customer Segmentation
WITH segmented AS (
    SELECT 
        customer_id,
        previous_purchases,
        purchase_amount,
        subscription_status,
        CASE 
            WHEN previous_purchases <= 2                                THEN 'New'
            WHEN previous_purchases BETWEEN 3 AND 10                   THEN 'Returning'
            WHEN previous_purchases > 10 AND purchase_amount >= 60     THEN 'High-Value Loyal'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customer
)
SELECT 
    customer_segment,
    COUNT(*)                                        AS total_customers,
    ROUND(AVG(purchase_amount)::NUMERIC, 2)         AS avg_spend,
    ROUND(SUM(purchase_amount)::NUMERIC, 2)         AS segment_revenue
FROM segmented
GROUP BY customer_segment
ORDER BY segment_revenue DESC;


-- Q8: Age Group Revenue + Subscription Rate
SELECT 
    age_group,
    COUNT(*)                                        AS total_customers,
    ROUND(SUM(purchase_amount)::NUMERIC, 2)         AS total_revenue,
    ROUND(AVG(purchase_amount)::NUMERIC, 2)         AS avg_spend,
    ROUND(
        100.0 * SUM(CASE WHEN subscription_status = 'Yes' THEN 1 ELSE 0 END) 
        / COUNT(*), 1
    )                                               AS subscription_rate_pct
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;


-- ============================================================
-- SECTION 4 : ADVANCED INSIGHTS
-- ============================================================

-- Q9: Running Total Revenue by Season
WITH seasonal AS (
    SELECT 
        season,
        ROUND(SUM(purchase_amount)::NUMERIC, 2)     AS season_revenue
    FROM customer
    GROUP BY season
)
SELECT 
    season,
    season_revenue,
    ROUND(
        SUM(season_revenue) OVER (
            ORDER BY season_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 2
    )                                               AS running_total
FROM seasonal;


-- Q10: Shipping Type vs Customer Satisfaction
SELECT 
    shipping_type,
    COUNT(*)                                        AS total_orders,
    ROUND(AVG(purchase_amount)::NUMERIC, 2)         AS avg_spend,
    ROUND(AVG(review_rating)::NUMERIC, 2)           AS avg_rating,
    ROUND(
        100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*), 1
    )                                               AS discount_usage_pct
FROM customer
GROUP BY shipping_type
ORDER BY avg_rating DESC;


-- Q11: High Spenders Who Don't Subscribe (Business Opportunity)
SELECT 
    customer_id,
    age_group,
    purchase_amount,
    previous_purchases,
    payment_method
FROM customer
WHERE subscription_status = 'No'
  AND purchase_amount > (SELECT AVG(purchase_amount) FROM customer)
  AND previous_purchases > 5
ORDER BY purchase_amount DESC
LIMIT 10;


-- Q12: Payment Method Preference by Age Group
WITH payment_pref AS (
    SELECT 
        age_group,
        payment_method,
        COUNT(*)                                    AS usage_count,
        RANK() OVER (
            PARTITION BY age_group 
            ORDER BY COUNT(*) DESC
        )                                           AS pref_rank
    FROM customer
    GROUP BY age_group, payment_method
)
SELECT age_group, payment_method, usage_count
FROM payment_pref
WHERE pref_rank = 1
ORDER BY age_group;


-- Q13: Season x Category Revenue Matrix (MIS Pivot-style Report)
SELECT 
    season,
    ROUND(SUM(CASE WHEN category = 'Clothing'    THEN purchase_amount ELSE 0 END)::NUMERIC, 2) AS clothing,
    ROUND(SUM(CASE WHEN category = 'Footwear'    THEN purchase_amount ELSE 0 END)::NUMERIC, 2) AS footwear,
    ROUND(SUM(CASE WHEN category = 'Accessories' THEN purchase_amount ELSE 0 END)::NUMERIC, 2) AS accessories,
    ROUND(SUM(CASE WHEN category = 'Outerwear'   THEN purchase_amount ELSE 0 END)::NUMERIC, 2) AS outerwear
FROM customer
GROUP BY season
ORDER BY season;

-- ============================================================
-- END OF ANALYSIS
-- ============================================================
