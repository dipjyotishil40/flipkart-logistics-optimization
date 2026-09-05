-- Flipkart Logistics Optimization
-- 04 - Route Analysis

USE flipkart_project;


-- ==========================================
-- 1. ROUTE ORDER VOLUME
-- ==========================================

SELECT
    route_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY route_id
ORDER BY total_orders DESC;


-- ==========================================
-- 2. ROUTE DELAY ANALYSIS
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

GROUP BY route_id
ORDER BY delay_percentage DESC;


-- ==========================================
-- 3. AVERAGE DELAY BY ROUTE
-- ==========================================

SELECT
    route_id,

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

GROUP BY route_id
ORDER BY avg_delay_days DESC;


-- ==========================================
-- 4. ROUTES WITH HIGH DELAY AND HIGH VOLUME
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

GROUP BY route_id

HAVING COUNT(*) >= 5

ORDER BY delay_percentage DESC, total_orders DESC;


-- ==========================================
-- 5. ROUTE PERFORMANCE RANKING
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
ORDER BY on_time_percentage ASC;
