CREATE VIEW V_gold_fact_sales AS

SELECT
    sd.sls_ord_num AS order_number,
    pr.product_key AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM
    silver_sales_details AS sd
    LEFT JOIN V_gold_dim_product AS pr ON sd.sls_prd_key = pr.product_number
    LEFT JOIN V_gold_dim_customer AS cu ON sd.sls_cust_id = cu.customer_id;

-- Check


SELECT * FROM V_gold_fact_sales;

SELECT *
FROM
    V_gold_fact_sales AS s
    JOIN V_gold_dim_customer AS c ON s.customer_key = c.customer_id
    JOIN V_gold_dim_product AS p ON s.product_key = p.product_id;
