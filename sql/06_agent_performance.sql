-- Flipkart Logistics Optimization
-- 06 - Agent Performance Analysis

USE flipkart_project;

-- =========================================
-- AGENT PERFORMANCE ANALYSIS
-- =========================================

-- 1. Overall performance of each delivery agent
SELECT
    agent_id,
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
    ) AS on_time_rate
FROM orders
GROUP BY agent_id
ORDER BY on_time_rate DESC;


-- 2. Average delivery delay by agent
SELECT
    agent_id,
    COUNT(*) AS total_orders,
    ROUND(
        AVG(DATEDIFF(actual_delivery_date, expected_delivery_date)),
        2
    ) AS avg_delay_days
FROM orders
GROUP BY agent_id
ORDER BY avg_delay_days;


-- 3. Agents with the highest number of delayed deliveries
SELECT
    agent_id,
    COUNT(*) AS delayed_deliveries
FROM orders
WHERE actual_delivery_date > expected_delivery_date
GROUP BY agent_id
ORDER BY delayed_deliveries DESC;


-- 4. Agent performance by order status
SELECT
    agent_id,
    status,
    COUNT(*) AS order_count
FROM orders
GROUP BY agent_id, status
ORDER BY agent_id, order_count DESC;


-- 5. Agents handling the most orders
SELECT
    agent_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY agent_id
ORDER BY total_orders DESC;


-- 6. Check available agents
SELECT DISTINCT agent_id
FROM orders
ORDER BY agent_id;
