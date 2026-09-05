-- Flipkart Logistics Optimization
-- 05 - Warehouse Analysis

USE flipkart_project;


-- ==========================================
-- 1. WAREHOUSE ORDER VOLUME
-- ==========================================

SELECT
    warehouse_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY warehouse_id
ORDER BY total_orders DESC;


-- ==========================================
-- 2. WAREHOUSE DELAY ANALYSIS
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
        100.0 * SUM(
            CASE
                WHEN actual_delivery_date > expected_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS delay_percentage

FROM orders
WHERE actual_delivery_date IS NOT NULL
  AND expected_delivery_date IS NOT NULL

GROUP BY warehouse_id
ORDER BY delay_percentage DESC;


-- ==========================================
-- 3. AVERAGE DELAY BY WAREHOUSE
-- ==========================================

SELECT
    warehouse_id,

    ROUND(
        AVG(
            CASE
                WHEN actual_delivery_date > expected_delivery_date
                THEN DATEDIFF(
                    actual_delivery_date,
                    expected_delivery_date
                )
            END
        ),
        2
    ) AS avg_delay_days

FROM orders
WHERE actual_delivery_date IS NOT NULL
  AND expected_delivery_date IS NOT NULL

GROUP BY warehouse_id
ORDER BY avg_delay_days DESC;


-- ==========================================
-- 4. WAREHOUSE ON-TIME PERFORMANCE
-- ==========================================

SELECT
    warehouse_id,
    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN actual_delivery_date <= expected_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS on_time_orders,

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
ORDER BY on_time_percentage ASC;


-- ==========================================
-- 5. HIGH-VOLUME AND HIGH-DELAY WAREHOUSES
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
        100.0 * SUM(
            CASE
                WHEN actual_delivery_date > expected_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS delay_percentage,

    ROUND(
        AVG(
            CASE
                WHEN actual_delivery_date > expected_delivery_date
                THEN DATEDIFF(
                    actual_delivery_date,
                    expected_delivery_date
                )
            END
        ),
        2
    ) AS avg_delay_days

FROM orders
WHERE actual_delivery_date IS NOT NULL
  AND expected_delivery_date IS NOT NULL

GROUP BY warehouse_id

HAVING COUNT(*) >= 5

ORDER BY delay_percentage DESC, total_orders DESC;
