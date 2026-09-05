-- Flipkart Logistics Optimization
-- 01 - Data Preparation & Cleaning

USE flipkart_project;

-- =========================================
-- ORDERS TABLE
-- =========================================

SELECT * FROM orders;
DESCRIBE orders;

ALTER TABLE orders MODIFY order_id VARCHAR(20);
ALTER TABLE orders MODIFY warehouse_id VARCHAR(10);
ALTER TABLE orders MODIFY route_id VARCHAR(10);
ALTER TABLE orders MODIFY agent_id VARCHAR(10);

ALTER TABLE orders MODIFY order_date DATE;
ALTER TABLE orders MODIFY expected_delivery_date DATE;
ALTER TABLE orders MODIFY actual_delivery_date DATE;

ALTER TABLE orders DROP MyUnknownColumn;
ALTER TABLE orders DROP COLUMN `MyUnknownColumn_[0]`;

ALTER TABLE orders MODIFY order_value DECIMAL(10,2);

DESCRIBE orders;


-- =========================================
-- ROUTES TABLE
-- =========================================

SELECT * FROM routes;
DESCRIBE routes;

ALTER TABLE routes MODIFY route_id VARCHAR(10);


-- =========================================
-- WAREHOUSES TABLE
-- =========================================

SELECT * FROM warehouses;
DESCRIBE warehouses;

ALTER TABLE warehouses MODIFY warehouse_id VARCHAR(10);


-- =========================================
-- SHIPMENT TRACKING TABLE
-- =========================================

SELECT * FROM shipment_tracking;
DESCRIBE shipment_tracking;

ALTER TABLE shipment_tracking MODIFY checkpoint_date DATE;
ALTER TABLE shipment_tracking MODIFY checkpoint_time TIME;
ALTER TABLE shipment_tracking MODIFY tracking_id VARCHAR(15);
ALTER TABLE shipment_tracking MODIFY order_id VARCHAR(20);


-- =========================================
-- DELIVERY AGENTS TABLE
-- =========================================

SELECT * FROM delivery_agents;
DESCRIBE delivery_agents;

ALTER TABLE delivery_agents MODIFY agent_id VARCHAR(10);
ALTER TABLE delivery_agents MODIFY route_id VARCHAR(10);
ALTER TABLE delivery_agents MODIFY avg_speed_kmph DECIMAL(10,2);
ALTER TABLE delivery_agents MODIFY On_Time_Delivery_Percentage DECIMAL(10,2);
ALTER TABLE delivery_agents MODIFY Experience_Years FLOAT;


-- =========================================
-- DATA QUALITY CHECKS
-- =========================================

-- Check for duplicate order IDs
SELECT 
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- Check for missing delivery dates
SELECT *
FROM orders
WHERE order_date IS NULL
   OR expected_delivery_date IS NULL
   OR actual_delivery_date IS NULL;


-- Check for invalid delivery dates
SELECT *
FROM orders
WHERE actual_delivery_date < order_date;


-- Check available order statuses
SELECT DISTINCT status
FROM orders;
