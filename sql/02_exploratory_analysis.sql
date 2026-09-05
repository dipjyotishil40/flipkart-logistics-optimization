-- Flipkart Logistics Optimization
-- 02 - Exploratory Analysis

USE flipkart_project;

-- ==========================================
-- 1. ORDER STATUS DISTRIBUTION
-- ==========================================

SELECT
    status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;


-- ==========================================
-- 2. ORDERS BY WAREHOUSE
-- ==========================================

SELECT
    warehouse_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY warehouse_id
ORDER BY total_orders DESC;


-- ==========================================
-- 3. ORDERS BY ROUTE
-- ==========================================

SELECT
    route_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY route_id
ORDER BY total_orders DESC;


-- ==========================================
-- 4. ORDERS BY AGENT
-- ==========================================

SELECT
    agent_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY agent_id
ORDER BY total_orders DESC;


-- ==========================================
-- 5. DELIVERY PERFORMANCE
-- ==========================================

SELECT
    status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;


-- ==========================================
-- 6. DELAYED ORDERS
-- ==========================================

SELECT
    order_id,
    warehouse_id,
    route_id,
    agent_id,
    order_date,
    expected_delivery_date,
    actual_delivery_date,
    DATEDIFF(actual_delivery_date, expected_delivery_date) AS delay_days
FROM orders
WHERE actual_delivery_date > expected_delivery_date
ORDER BY delay_days DESC;


-- ==========================================
-- 7. AVERAGE DELIVERY DELAY BY WAREHOUSE
-- ==========================================

SELECT
    warehouse_id,
    AVG(
        DATEDIFF(actual_delivery_date, expected_delivery_date)
    ) AS avg_delay_days
FROM orders
WHERE actual_delivery_date > expected_delivery_date
GROUP BY warehouse_id
ORDER BY avg_delay_days DESC;


-- ==========================================
-- 8. AVERAGE DELIVERY DELAY BY ROUTE
-- ==========================================

SELECT
    route_id,
    AVG(
        DATEDIFF(actual_delivery_date, expected_delivery_date)
    ) AS avg_delay_days
FROM orders
WHERE actual_delivery_date > expected_delivery_date
GROUP BY route_id
ORDER BY avg_delay_days DESC;


-- ==========================================
-- 9. AGENT PERFORMANCE
-- ==========================================

SELECT
    agent_id,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN actual_delivery_date > expected_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS delayed_orders
FROM orders
GROUP BY agent_id
ORDER BY delayed_orders DESC;


-- ==========================================
-- 10. MONTHLY ORDER VOLUME
-- ==========================================

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    order_year,
    order_month;
