-- load_data.sql
-- Ran from the PROJECT ROOT using psql so the relative paths below resolve:
--   psql -h localhost -U postgres -d retail_datawarehouse -f sql/02_load_data.sql
--
-- \This file copy runs/raw data on my local (client side), so it works even if Postgres
-- is in Docker. Each \copy command stays on a single line.
-- Empty unquoted CSV fields are loaded as NULL.

\copy raw.customers FROM 'data set/olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy raw.orders FROM 'data set/olist_orders_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy raw.order_items FROM 'data set/olist_order_items_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy raw.products FROM 'data set/olist_products_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy raw.sellers FROM 'data set/olist_sellers_dataset.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
\copy raw.product_category_translation FROM 'data set/product_category_name_translation.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')