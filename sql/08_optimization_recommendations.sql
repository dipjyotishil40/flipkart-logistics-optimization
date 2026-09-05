-- Flipkart Logistics Optimization
-- 08 - Optimization Recommendations

USE flipkart_project;

-- =========================================
-- LOGISTICS OPTIMIZATION ANALYSIS
-- =========================================

-- 1. Identify routes with the highest delivery delays
SELECT
    route_id,
    COUNT(*) AS total_orders,
    ROUND(
        AVG(DATEDIFF(actual_delivery_date, expected_delivery_date)),
        2
    ) AS avg_delay_days
FROM orders
GROUP BY route_id
ORDER BY avg_delay_days DESC;


-- 2. Identify warehouses with the highest delivery delays
SELECT
    warehouse_id,
    COUNT(*) AS total_orders,
    ROUND(
        AVG(DATEDIFF(actual_delivery_date, expected_delivery_date)),
        2
    ) AS avg_delay_days
FROM orders
GROUP BY warehouse_id
ORDER BY avg_delay_days DESC;


-- 3. Identify agents with poor on-time performance
SELECT
    agent_id,
    COUNT(*) AS total_orders,
    ROUND(
        100.0 * SUM(CASE
            WHEN actual_delivery_date <= expected_delivery_date
            THEN 1 ELSE 0
        END) / COUNT(*),
        2
    ) AS on_time_rate
FROM orders
GROUP BY agent_id
HAVING on_time_rate < 80
ORDER BY on_time_rate;


-- 4. Identify high-volume routes
SELECT
    route_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY route_id
ORDER BY total_orders DESC;


-- 5. Identify high-volume warehouses
SELECT
    warehouse_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY warehouse_id
ORDER BY total_orders DESC;


-- 6. Overall delayed-order analysis
SELECT
    status,
    COUNT(*) AS delayed_orders
FROM orders
WHERE actual_delivery_date > expected_delivery_date
GROUP BY status
ORDER BY delayed_orders DESC;
