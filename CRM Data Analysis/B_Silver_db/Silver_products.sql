CREATE TABLE silver_products (
    product VARCHAR(50),
    series VARCHAR(50),
    sales_price DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO silver_products (
    product,
    series,
    sales_price
)
SELECT 
    CONCAT(
        UPPER(LEFT(COALESCE(product, 'Unknown'), 1)),
        LOWER(SUBSTRING(COALESCE(product, 'Unknown'), 2))
    ) AS product,
    CONCAT(
        UPPER(LEFT(COALESCE(series, 'N/A'), 1)),
        LOWER(SUBSTRING(COALESCE(series, 'N/A'), 2))
    ) AS series,
    COALESCE(sales_price, 0.00) AS sales_price
FROM (
    SELECT 
        product,
        series,
        sales_price,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(product) 
            ORDER BY sales_price DESC
        ) AS rn
    FROM bronze_products
    WHERE product IS NOT NULL
) AS sub
WHERE rn = 1;
SELECT * FROM silver_products;