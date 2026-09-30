CREATE TABLE silver_sales_teams (
    sales_agent VARCHAR(50) PRIMARY KEY,
    manager_name VARCHAR(50),
    regional_office VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO silver_sales_teams (
    sales_agent,
    manager_name,
    regional_office
)
SELECT 
    CONCAT(
        UPPER(LEFT(COALESCE(sales_agent, 'Unknown Agent'), 1)),
        LOWER(SUBSTRING(COALESCE(sales_agent, 'Unknown Agent'), 2))
    ) AS sales_agent,
    CONCAT(
        UPPER(LEFT(COALESCE(manager_name, 'No Manager'), 1)),
        LOWER(SUBSTRING(COALESCE(manager_name, 'No Manager'), 2))
    ) AS manager_name,
    CONCAT(
        UPPER(LEFT(COALESCE(regional_office, 'N/A'), 1)),
        LOWER(SUBSTRING(COALESCE(regional_office, 'N/A'), 2))
    ) AS regional_office
FROM (
    SELECT 
        sales_agent,
        manager AS manager_name,
        regional_office,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(sales_agent) 
            ORDER BY manager DESC
        ) AS rn
    FROM bronze_sales_teams
    WHERE sales_agent IS NOT NULL
) AS sub
WHERE rn = 1;

SELECT * FROM silver_sales_teams;