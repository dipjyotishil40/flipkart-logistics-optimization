-- Flipkart Logistics Optimization
-- 03 - Delivery Performance Analysis

USE flipkart_project;


-- ==========================================
-- 1. OVERALL DELIVERY PERFORMANCE
-- ==========================================

SELECT
    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN actual_delivery_date <= expected_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS on_time_orders,

    SUM(
        CASE
            WHEN actual_delivery_date > expected_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS delayed_orders,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN actual_delivery_date <= expected_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS on_time_percentage

FROM orders
WHERE actual_delivery_date IS NOT NULL
  AND expected_delivery_date IS NOT NULL;


-- ==========================================
-- 2. DELAY SEVERITY
-- ==========================================

SELECT
    CASE
        WHEN DATEDIFF(actual_delivery_date, expected_delivery_date) = 1
            THEN '1 Day Delay'
        WHEN DATEDIFF(actual_delivery_date, expected_delivery_date) BETWEEN 2 AND 3
            THEN '2-3 Days Delay'
        WHEN DATEDIFF(actual_delivery_date, expected_delivery_date) BETWEEN 4 AND 7
            THEN '4-7 Days Delay'
        WHEN DATEDIFF(actual_delivery_date, expected_delivery_date) > 7
            THEN 'More Than 7 Days'
        ELSE 'On Time / Early'
    END AS delay_category,

    COUNT(*) AS total_orders

FROM orders
WHERE actual_delivery_date IS NOT NULL
  AND expected_delivery_date IS NOT NULL

GROUP BY
    CASE
        WHEN DATEDIFF(actual_delivery_date, expected_delivery_date) = 1
            THEN '1 Day Delay'
        WHEN DATEDIFF(actual_delivery_date, expected_delivery_date) BETWEEN 2 AND 3
            THEN '2-3 Days Delay'
        WHEN DATEDIFF(actual_delivery_date, expected_delivery_date) BETWEEN 4 AND 7
            THEN '4-7 Days Delay'
        WHEN DATEDIFF(actual_delivery_date, expected_delivery_date) > 7
            THEN 'More Than 7 Days'
        ELSE 'On Time / Early'
    END

ORDER BY total_orders DESC;


-- ==========================================
-- 3. WAREHOUSE DELIVERY PERFORMANCE
-- ==========================================

SELECT
    warehouse_id,
    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN actual_delivery_date > expected_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS delayed_orders,

    ROUND(
        AVG(
            CASE
                WHEN actual_delivery_date > expected_delivery_date
                THEN DATEDIFF(actual_delivery_date, expected_delivery_date)
            END
        ),
        2
    ) AS avg_delay_days,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN actual_delivery_date <= expected_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS on_time_percentage

FROM orders
WHERE actual_delivery_date IS NOT NULL
  AND expected_delivery_date IS NOT NULL

GROUP BY warehouse_id
ORDER BY avg_delay_days DESC;


-- ==========================================
-- 4. ROUTE DELIVERY PERFORMANCE
-- ==========================================

SELECT
    route_id,
    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN actual_delivery_date > expected_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS delayed_orders,

    ROUND(
        AVG(
            CASE
                WHEN actual_delivery_date > expected_delivery_date
                THEN DATEDIFF(actual_delivery_date, expected_delivery_date)
            END
        ),
        2
    ) AS avg_delay_days,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN actual_delivery_date <= expected_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS on_time_percentage

FROM orders
WHERE actual_delivery_date IS NOT NULL
  AND expected_delivery_date IS NOT NULL

GROUP BY route_id
ORDER BY avg_delay_days DESC;


-- ==========================================
-- 5. AGENT DELIVERY PERFORMANCE
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
    ) AS delayed_orders,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN actual_delivery_date <= expected_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS on_time_percentage

FROM orders
WHERE actual_delivery_date IS NOT NULL
  AND expected_delivery_date IS NOT NULL

GROUP BY agent_id
ORDER BY on_time_percentage ASC;


-- ==========================================
-- 6. MOST DELAYED ORDERS
-- ==========================================

SELECT
    order_id,
    warehouse_id,
    route_id,
    agent_id,
    order_date,
    expected_delivery_date,
    actual_delivery_date,

    DATEDIFF(
        actual_delivery_date,
        expected_delivery_date
    ) AS delay_days

FROM orders
WHERE actual_delivery_date > expected_delivery_date

ORDER BY delay_days DESC;
