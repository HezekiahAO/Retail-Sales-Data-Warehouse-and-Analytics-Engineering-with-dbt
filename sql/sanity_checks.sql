-- sanity_checks.sql
-- This verifies the load and start collecting your data-quality findings.
-- Record the results: As they feed my dataset justification and the "data quality issues" slide.

-- 1. Row counts (Olist public version should be roughly:
--    customers 99,441 | orders 99,441 | order_items 112,650
--    products 32,951  | sellers 3,095  | translation 71)
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM raw.customers
UNION ALL SELECT 'orders',        COUNT(*) FROM raw.orders
UNION ALL SELECT 'order_items',   COUNT(*) FROM raw.order_items
UNION ALL SELECT 'products',      COUNT(*) FROM raw.products
UNION ALL SELECT 'sellers',       COUNT(*) FROM raw.sellers
UNION ALL SELECT 'category_translation', COUNT(*) FROM raw.product_category_translation;

-- 2. Look at the data
SELECT * FROM raw.customers   LIMIT 20;
SELECT * FROM raw.orders      LIMIT 20;
SELECT * FROM raw.order_items LIMIT 20;
SELECT * FROM raw.products    LIMIT 20;
SELECT * FROM raw.sellers     LIMIT 20;
SELECT * FROM raw.product_category_translation LIMIT 20;

-- 3. Key uniqueness (expect 0 duplicates in each)
SELECT 'orders.order_id' AS key_checked, COUNT(*) - COUNT(DISTINCT order_id) AS duplicates FROM raw.orders
UNION ALL SELECT 'customers.customer_id', COUNT(*) - COUNT(DISTINCT customer_id) FROM raw.customers
UNION ALL SELECT 'products.product_id',   COUNT(*) - COUNT(DISTINCT product_id)  FROM raw.products
UNION ALL SELECT 'sellers.seller_id',     COUNT(*) - COUNT(DISTINCT seller_id)   FROM raw.sellers
UNION ALL SELECT 'order_items (order_id, order_item_id)',
       COUNT(*) - COUNT(DISTINCT (order_id, order_item_id)) FROM raw.order_items;

-- 4. customer_id vs customer_unique_id (the classic trap)
SELECT COUNT(DISTINCT customer_id)        AS distinct_customer_ids,
       COUNT(DISTINCT customer_unique_id) AS distinct_real_customers
FROM raw.customers;

-- 5. Orphan checks (expect 0 for each)
SELECT COUNT(*) AS items_without_order
FROM raw.order_items oi LEFT JOIN raw.orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS orders_without_customer
FROM raw.orders o LEFT JOIN raw.customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS items_without_product
FROM raw.order_items oi LEFT JOIN raw.products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 6. Order status values (decide later which count as a "sale")
SELECT order_status, COUNT(*) AS orders
FROM raw.orders GROUP BY order_status ORDER BY orders DESC;

-- 7. Date range and monthly volume (look for sparse early/late months)
SELECT MIN(order_purchase_timestamp) AS first_order,
       MAX(order_purchase_timestamp) AS last_order
FROM raw.orders;

SELECT DATE_TRUNC('month', order_purchase_timestamp)::date AS month, COUNT(*) AS orders
FROM raw.orders GROUP BY 1 ORDER BY 1;

-- 8. Missing categories and untranslated categories
SELECT COUNT(*) AS products_with_null_category
FROM raw.products WHERE product_category_name IS NULL;

SELECT DISTINCT p.product_category_name AS untranslated_category
FROM raw.products p
LEFT JOIN raw.product_category_translation t ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL AND t.product_category_name IS NULL;

-- 9. Price sanity (look for zero/negative prices)
SELECT MIN(price) AS min_price, MAX(price) AS max_price, AVG(price)::numeric(10,2) AS avg_price, 
       MIN(freight_value) AS min_freight, MAX(freight_value) AS max_freight
FROM raw.order_items;