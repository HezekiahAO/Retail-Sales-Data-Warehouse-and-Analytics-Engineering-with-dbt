-- Added keys to the raw tables to ensure data integrity and uniqueness of records(This was after the data was tested and confirmed btw,).

ALTER TABLE raw.customers   ADD PRIMARY KEY (customer_id);
ALTER TABLE raw.orders      ADD PRIMARY KEY (order_id);
ALTER TABLE raw.products    ADD PRIMARY KEY (product_id);
ALTER TABLE raw.sellers     ADD PRIMARY KEY (seller_id);
ALTER TABLE raw.order_items ADD PRIMARY KEY (order_id, order_item_id);
ALTER TABLE raw.product_category_translation ADD PRIMARY KEY (product_category_name);