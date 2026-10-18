USE VoltNestAnalytics;
GO

-- =========================================================
--1. Which marketing channels acquire the most customers
-- =========================================================
-- Customer acquisition and revenue by channel

SELECT
    channel,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(total_orders) AS total_orders,
    SUM(total_revenue) AS total_revenue,
    AVG(total_revenue) AS avg_revenue_per_customer
FROM Vsch.customer_summary
GROUP BY channel
ORDER BY total_customers DESC;



-- insights from query 1
-- organic search leads with 650 customers, followed by paid social with 642
-- Paid Social is a strong acquisition channel, ranking second in both total customers and total revenue
-- Direct had the highest average revenue per customer, at 180.51, despite having the fewest customers







-- =========================================================
-- 2:Which campaigns generate the highest website traffic and 
--   session-to-purchase conversion rates?
-- =========================================================


-- Campaign traffic and conversion performance

SELECT
    c.campaign_name,
    c.channel,
    COUNT(s.session_id) AS total_sessions,
    SUM(CASE WHEN s.converted = 1 THEN 1 ELSE 0 END) AS converted_sessions,
    CAST(
         100.0 * SUM(CASE WHEN s.converted = 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(s.session_id), 0)
        AS DECIMAL(5,2)
    ) AS conversion_rate
FROM Vsch.campaigns c
LEFT JOIN Vsch.website_sessions s
    ON c.campaign_id = s.campaign_id
GROUP BY
    c.campaign_name,
    c.channel
ORDER BY conversion_rate DESC;

-- insights from query 2
-- Email campaign 1 has the best conversion rate of 17.07%, with 321 converted sessions
-- All 3 email campaigns performed well, ranking the highest for conversion rates amongst
-- all campaigns
-- paid social is genereating subsantial traffic highest being 3852 sessions,but 
-- conversion rates are significanlty lower ranging from 4.35% to 7.84%
-- display campaigns have the lowest conversion rates, the lowest being 2.75%





-- =========================================================
-- Question 3: Which paid campaigns deliver the best return on 
-- marketing spend (ROAS)?
-- =========================================================

-- Campaign-level return on marketing spend

WITH campaign_revenue AS (
    SELECT
        s.campaign_id,
        SUM(o.net_revenue) AS attributed_revenue
    FROM Vsch.website_sessions s
    INNER JOIN Vsch.orders o
        ON s.session_id = o.session_id
    GROUP BY s.campaign_id
),
campaign_spend AS (
    SELECT
        campaign_id,
        SUM(spend_amount) AS total_spend
    FROM Vsch.marketing_spend
    GROUP BY campaign_id
)
SELECT
    c.campaign_name,
    c.channel,
    FORMAT(COALESCE(cs.total_spend, 0), 'N2') AS total_spend,
    FORMAT(COALESCE(cr.attributed_revenue, 0), 'N2') AS attributed_revenue,
    CAST(
        COALESCE(cr.attributed_revenue, 0)
        / NULLIF(cs.total_spend, 0)
        AS DECIMAL(10,2)
    ) AS ROAS
FROM Vsch.campaigns c
LEFT JOIN campaign_spend cs
    ON c.campaign_id = cs.campaign_id
LEFT JOIN campaign_revenue cr
    ON c.campaign_id = cr.campaign_id
WHERE c.cost_tracking_available = 1
ORDER BY ROAS DESC;


-- insights from query 3

-- Email campaigns perform best in terms of revenue relative to marketing spend.
-- Email Campaign 2 generated 39,942.24 in revenue against 12,553.80 in spend,
-- giving it the highest ROAS of approximately 3.18:1.

-- Paid Social is the only paid channel with ROAS above 1.0:1.
-- Paid Social Campaign 1 achieved a ROAS of approximately 1.35:1.

-- Paid Search campaigns underperform significantly, with high marketing spend
-- relative to attributed revenue. Paid Search Campaign 3 had the highest spend
-- at approximately 129,179.37, but achieved a ROAS of only 0.26:1.

-- Display campaigns also underperform, with ROAS ranging from approximately
-- 0.42:1 to 0.71:1. Their attributed revenue is below their marketing spend.





-- =========================================================
-- 4: At which stage of the website funnel do the most sessions drop off?
-- =========================================================


-- Website funnel analysis

SELECT
    COUNT(*) AS total_sessions,

    SUM(CASE WHEN product_view = 1 THEN 1 ELSE 0 END) AS product_view_sessions,

    SUM(CASE WHEN add_to_cart = 1 THEN 1 ELSE 0 END) AS add_to_cart_sessions,

    SUM(CASE WHEN checkout_started = 1 THEN 1 ELSE 0 END) AS checkout_sessions,

    SUM(CASE WHEN purchase = 1 THEN 1 ELSE 0 END) AS purchase_sessions,

    CAST(
        100.0 * SUM(CASE WHEN add_to_cart = 1 THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN product_view = 1 THEN 1 ELSE 0 END), 0)
        AS DECIMAL(5,2)
    ) AS product_view_to_cart_pct,

    CAST(
        100.0 * SUM(CASE WHEN checkout_started = 1 THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN add_to_cart = 1 THEN 1 ELSE 0 END), 0)
        AS DECIMAL(5,2)
    ) AS cart_to_checkout_pct,

    CAST(
        100.0 * SUM(CASE WHEN purchase = 1 THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN checkout_started = 1 THEN 1 ELSE 0 END), 0)
        AS DECIMAL(5,2)
    ) AS checkout_to_purchase_pct

FROM Vsch.website_sessions;


-- All 45,000 sessions viewed a product.
--Only 18,454 sessions added a product to the cart, meaning 41.01% of product-view 
--sessions progressed to adding a product to the cart.
--11,869 sessions reached checkout, representing 64.32% of sessions that added a 
--product to the cart.
-- Only 4,278 sessions resulted in a purchase, meaning 36.04% of checkout sessions 
--converted into purchases.
-- the The overall session-to-purchase conversion rate was 9.51%




-- =========================================================
-- 5: Which campaigns have the highest click-through rates (CTR)?
-- =========================================================

-- Campaign click-through rate (CTR)

SELECT
    c.campaign_name,
    c.channel,
    SUM(ms.impressions) AS total_impressions,
    SUM(ms.clicks) AS total_clicks,
    CAST(
        100.0 * SUM(ms.clicks) / NULLIF(SUM(ms.impressions), 0)
        AS DECIMAL(5,2)
    ) AS ctr_pct
FROM Vsch.marketing_spend ms
JOIN Vsch.campaigns c
    ON ms.campaign_id = c.campaign_id
GROUP BY
    c.campaign_name,
    c.channel
ORDER BY ctr_pct DESC;


-- Email campaigns lead in click engagement. All three Email campaigns have CTRs above 5.4%, with Email Campaign 1 ranking first at 6.30%
-- Paid Search performs well at generating clicks. Paid Search Campaign 2 achieves a 5.23% CTR, while Campaign 1 is noticeably lower at 3.42%. This suggests performance varies even within the same channel.
--Paid Social generates substantial impressions but relatively low click engagement. Its CTRs range from 1.91% to 2.68%.
--Display campaigns have the lowest CTRs. Display Campaign 1 records 0.77% despite more than 4.1 million impressions. The campaigns may need a closer review of their targeting, creative, and audience relevance.



-- =========================================================
-- 6: What is the customer acquisition cost (CAC) for each marketing channel?
-- =========================================================



-- Customer acquisition cost (CAC) by channel

WITH channel_spend AS (
    SELECT
        c.channel,
        SUM(ms.spend_amount) AS total_spend
    FROM Vsch.marketing_spend ms
    JOIN Vsch.campaigns c
        ON ms.campaign_id = c.campaign_id
    GROUP BY c.channel
),
channel_customers AS (
    SELECT
        channel,
        COUNT(DISTINCT customer_id) AS acquired_customers
    FROM Vsch.customer_summary
    GROUP BY channel
)
SELECT
    cc.channel,
    cc.acquired_customers,
    CAST(cs.total_spend AS DECIMAL(18,2)) AS total_spend,
    CAST(
        cs.total_spend / NULLIF(cc.acquired_customers, 0)
        AS DECIMAL(18,2)
    ) AS cac
FROM channel_customers cc
LEFT JOIN channel_spend cs
    ON cc.channel = cs.channel
ORDER BY cac;


-- insights from query 6
--email is the most cost-efficient measured channel, with a CAC of 87.96 
--per customer

--display is close in cost efficinecy to email, at 95.70 per customer.

--Paid Social has a much higher CAC, at 213.09 per customer, approximately 
--2.42 times Email's CAC.

--Paid Search has the highest measured CAC, at 487.54 per customer.







-- =========================================================
-- 7: How do discounts and refunds affect net revenue and average order value?
-- =========================================================


-- Impact of discounts and refunds on revenue

SELECT
    COUNT(*) AS total_orders,
    CAST(SUM(gross_revenue) AS DECIMAL(18,2)) AS gross_revenue,
    CAST(SUM(discount_amount) AS DECIMAL(18,2)) AS total_discounts,
    CAST(SUM(refund_amount) AS DECIMAL(18,2)) AS total_refunds,
    CAST(SUM(net_revenue) AS DECIMAL(18,2)) AS net_revenue,
    CAST(
        100.0 * SUM(discount_amount)
        / NULLIF(SUM(gross_revenue), 0)
        AS DECIMAL(5,2)
    ) AS discount_rate_pct,
    CAST(
        100.0 * SUM(refund_amount)
        / NULLIF(SUM(gross_revenue), 0)
        AS DECIMAL(5,2)
    ) AS refund_rate_pct,
    CAST(
        SUM(net_revenue) / NULLIF(COUNT(*), 0)
        AS DECIMAL(18,2)
    ) AS average_net_revenue_per_order
FROM Vsch.orders;




-- Insights 
--The business retains approximately 94.87% of its gross revenue after discounts and refunds. Discounts have a larger financial impact than refunds in absolute terms, accounting for 20,696.24 compared with 7,906.76 in refunds.




-- =========================================================
-- 8. How many customers make repeat purchases?
-- =========================================================


-- Repeat purchase analysis

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN total_orders = 1 THEN 1 ELSE 0 END) AS one_time_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    CAST(
        100.0 * SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(5,2)
    ) AS repeat_customer_rate_pct
FROM Vsch.customer_summary;


--Out of 3,302 customers, 779 customers (23.59%) made more than one purchase, while 2,523 customers (76.41%) purchased only once.






-- =========================================================
-- 9. How long does it take customers to make their second purchase?
-- =========================================================

-- Time taken to make a second purchase

SELECT
    COUNT(*) AS repeat_customers,
    CAST(AVG(CAST(days_to_second_order AS DECIMAL(10,2)))
        AS DECIMAL(10,2)) AS avg_days_to_second_order,
    MIN(days_to_second_order) AS min_days,
    MAX(days_to_second_order) AS max_days
FROM Vsch.customer_summary
WHERE days_to_second_order IS NOT NULL;

-- insighst fro query 9
--Out of 779 repeat customers, the average time between the first and second purchase was 191.5 days, or approximately 6 months. The shortest time was 0 days, meaning some customers made their second purchase on the same day as their first. The longest time was 515 days.




-- =========================================================
-- 10. Which marketing channels bring in the most valuable customers?
-- =========================================================


-- Customer value by acquisition channel

SELECT
    channel,
    COUNT(*) AS total_customers,
    CAST(SUM(total_revenue) AS DECIMAL(18,2)) AS total_revenue,
    CAST(AVG(total_revenue) AS DECIMAL(18,2)) AS avg_revenue_per_customer,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    CAST(
        100.0 * SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(5,2)
    ) AS repeat_customer_rate_pct
FROM Vsch.customer_summary
GROUP BY channel
ORDER BY avg_revenue_per_customer DESC;


-- Organic Search acquired the most customers (650) and generated the highest total revenue (113,296.36).

--Direct had the highest average revenue per customer (180.51) and the highest repeat customer rate (28.41%).

--Paid Search had a repeat customer rate of 25.25%, higher than Organic Search and Paid Social.

--Paid Social acquired 642 customers and generated 108,214.85 in revenue, but its repeat customer rate was 22.90%

--Email had the lowest average revenue per customer (158.55) and the lowest repeat customer rate (19.82%).

