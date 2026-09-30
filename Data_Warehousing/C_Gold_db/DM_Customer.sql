-- Dimention customer
CREATE VIEW V_gold_dim_customer AS

WITH
    customer_data AS (
        SELECT
            ci.cst_id AS customer_id,
            ci.cst_key AS customer_number,
            ci.cst_firstname AS first_name,
            ci.cst_lastname AS last_name,
            la.cntry AS country,
            ci.cst_marital_status AS marital_status,
            CASE
                WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
                ELSE COALESCE(ca.gen, 'n/a')
            END AS gender,
            ca.bdate AS birthdate,
            ci.cst_create_date AS create_date,
            ROW_NUMBER() OVER (
                PARTITION BY
                    ci.cst_id
                ORDER BY ci.cst_create_date DESC
            ) AS rn
        FROM
            silver_cust_info AS ci
            LEFT JOIN silver_cust_az12 AS ca ON ci.cst_key = ca.cid
            LEFT JOIN silver_loc_a101 AS la ON ci.cst_key = la.cid
    )
SELECT
    ROW_NUMBER() OVER (
        ORDER BY customer_id
    ) AS customer_key,
    customer_id,
    customer_number,
    first_name,
    last_name,
    country,
    marital_status,
    gender,
    birthdate,
    create_date
FROM customer_data
WHERE
    rn = 1;
