CREATE TABLE silver_sales_pipeline (
    opportunity_id VARCHAR(50) PRIMARY KEY,
    sales_agent VARCHAR(50),
    product_name VARCHAR(50),
    account_name VARCHAR(50),
    deal_stage VARCHAR(50),
    engage_date DATE,
    close_date DATE,
    close_value DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO silver_sales_pipeline (
    opportunity_id,
    sales_agent,
    product_name,
    account_name,
    deal_stage,
    engage_date,
    close_date,
    close_value
)
SELECT 
    opportunity_id,
    COALESCE(sales_agent, 'Unassigned') AS sales_agent,
    CONCAT(
        UPPER(LEFT(COALESCE(product_name, 'Unknown'), 1)),
        LOWER(SUBSTRING(COALESCE(product_name, 'Unknown'), 2))
    ) AS product_name,
    COALESCE(account_name, 'N/A') AS account_name,
    CONCAT(
        UPPER(LEFT(COALESCE(deal_stage, 'Unknown'), 1)),
        LOWER(SUBSTRING(COALESCE(deal_stage, 'Unknown'), 2))
    ) AS deal_stage,
    engage_date,
    close_date,
    COALESCE(close_value, 0.00) AS close_value
FROM (
    SELECT 
        opportunity_id,
        sales_agent,
        product AS product_name,
        account AS account_name,
        deal_stage,
        engage_date,
        close_date,
        close_value,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(opportunity_id) 
            ORDER BY engage_date DESC, close_date DESC
        ) AS rn
    FROM bronze_sales_pipeline
    WHERE opportunity_id IS NOT NULL
) AS sub
WHERE rn = 1;
SELECT * FROM silver_sales_pipeline;