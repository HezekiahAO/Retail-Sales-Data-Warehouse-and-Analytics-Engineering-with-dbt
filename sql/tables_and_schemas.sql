-- create_tables_and_schema.sql
-- I am creating the "operational" schema and raw tables for the Olist dataset.
-- Raw tables mirror the CSVs as-is (including Olist's misspelled column names).
-- Cleaning and renaming happens later, in dbt staging models.

CREATE SCHEMA IF NOT EXISTS raw;

DROP TABLE IF EXISTS raw.order_items;
DROP TABLE IF EXISTS raw.orders;
DROP TABLE IF EXISTS raw.customers;
DROP TABLE IF EXISTS raw.products;
DROP TABLE IF EXISTS raw.sellers;
DROP TABLE IF EXISTS raw.product_category_translation;

CREATE TABLE raw.customers (
    customer_id               TEXT,
    customer_unique_id        TEXT,
    customer_zip_code_prefix  TEXT,      -- TEXT keeps leading zeros
    customer_city             TEXT,
    customer_state            TEXT
);

CREATE TABLE raw.orders (
    order_id                       TEXT,
    customer_id                    TEXT,
    order_status                   TEXT,
    order_purchase_timestamp       TIMESTAMP,
    order_approved_at              TIMESTAMP,
    order_delivered_carrier_date   TIMESTAMP,
    order_delivered_customer_date  TIMESTAMP,
    order_estimated_delivery_date  TIMESTAMP
);

CREATE TABLE raw.order_items (
    order_id             TEXT,
    order_item_id        INTEGER,        -- line number within the order, NOT a quantity
    product_id           TEXT,
    seller_id            TEXT,
    shipping_limit_date  TIMESTAMP,
    price                NUMERIC(12,2),
    freight_value        NUMERIC(12,2)
);

CREATE TABLE raw.products (
    product_id                   TEXT,
    product_category_name        TEXT,
    product_name_lenght          NUMERIC,   -- sic: misspelled in source
    product_description_lenght   NUMERIC,   -- sic: misspelled in source
    product_photos_qty           NUMERIC,
    product_weight_g             NUMERIC,
    product_length_cm            NUMERIC,
    product_height_cm            NUMERIC,
    product_width_cm             NUMERIC
);

CREATE TABLE raw.sellers (
    seller_id               TEXT,
    seller_zip_code_prefix  TEXT,
    seller_city             TEXT,
    seller_state            TEXT
);

CREATE TABLE raw.product_category_translation (
    product_category_name          TEXT,
    product_category_name_english  TEXT
);