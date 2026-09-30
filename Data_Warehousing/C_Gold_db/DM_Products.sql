-- Dimention Product
CREATE VIEW V_gold_dim_product AS

WITH
    product_data AS (
        SELECT
            pi.prd_id AS product_id,
            pi.prd_key AS product_number,
            pi.prd_nm AS product_name,
            pi.cat_id AS category_id,
            pcg.CAT AS category,
            pcg.SUBCAT AS subcategory,
            pcg.MAINTENANCE AS maintenance,
            pi.prd_cost AS cost,
            pi.prd_line AS product_line,
            ROW_NUMBER() OVER (
                PARTITION BY
                    pi.prd_key
                ORDER BY pi.prd_start_dt DESC
            ) AS rn
        FROM
            silver_prd_info AS pi
            LEFT JOIN silver_px_cat_g1v2 AS pcg ON pi.cat_id = pcg.id
    )
SELECT
    ROW_NUMBER() OVER (
        ORDER BY product_id
    ) AS product_key,
    product_id,
    product_number,
    product_name,
    category_id,
    category,
    subcategory,
    maintenance,
    cost,
    product_line
FROM product_data
WHERE
    rn = 1;
SELECT * FROM V_gold_dim_product