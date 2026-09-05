-- Flipkart Logistics Optimization
-- 07 - Logistics Summary Analysis

USE flipkart_project;

-- =========================================
-- OVERALL LOGISTICS PERFORMANCE
-- =========================================

-- 1. Total orders
SELECT
    COUNT(*) AS total_orders
FROM orders;


-- 2. Overall on-time delivery rate
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE
        WHEN actual_delivery_date <= expected_delivery_date
        THEN 1 ELSE 0
    END) AS on_time_deliveries,
    ROUND(
        100.0 * SUM(CASE
            WHEN actual_delivery_date <= expected_delivery_date
            THEN 1 ELSE 0
        END) / COUNT(*),
        2
    ) AS overall_on_time_rate
FROM orders;


-- 3. Total delayed deliveries
SELECT
    COUNT(*) AS delayed_deliveries
FROM orders
WHERE actual_delivery_date > expected_delivery_date;


-- 4. Average delivery delay
SELECT
    ROUND(
        AVG(DATEDIFF(actual_delivery_date, expected_delivery_date)),
        2
    ) AS average_delay_days
FROM orders
WHERE actual_delivery_date > expected_delivery_date;


-- 5. Order status distribution
SELECT
    status,
    COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;


-- 6. Overall delivery performance summary
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE
        WHEN actual_delivery_date <= expected_delivery_date
        THEN 1 ELSE 0
    END) AS on_time_deliveries,
    SUM(CASE
        WHEN actual_delivery_date > expected_delivery_date
        THEN 1 ELSE 0
    END) AS delayed_deliveries,
    ROUND(
        100.0 * SUM(CASE
            WHEN actual_delivery_date <= expected_delivery_date
            THEN 1 ELSE 0
        END) / COUNT(*),
        2
    ) AS on_time_rate
FROM orders;
