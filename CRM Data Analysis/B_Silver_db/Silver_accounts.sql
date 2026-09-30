CREATE TABLE silver_accounts (
    account VARCHAR(50),
    sector VARCHAR(50),
    year_established INT,
    revenue DECIMAL(10,2),
    employees INT,
    office_location VARCHAR(100),
    subsidiary_of VARCHAR(100),
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO silver_accounts (
    account,
    sector,
    year_established,
    revenue,
    employees,
    office_location,
    subsidiary_of
)
SELECT 
    account,
    CONCAT(
        UPPER(LEFT(COALESCE(sector, 'Unknown'), 1)), 
        LOWER(SUBSTRING(COALESCE(sector, 'Unknown'), 2))
    ) AS sector,
    year_established,
    COALESCE(revenue, 0.00) AS revenue,
    COALESCE(employees, 0) AS employees,
    COALESCE(office_location, 'N/A') AS office_location,
    COALESCE(subsidiary_of, 'None') AS subsidiary_of
FROM (
    SELECT 
        account,
        sector,
        year_established,
        revenue,
        employees,
        office_location,
        subsidiary_of,
        ROW_NUMBER() OVER (
            PARTITION BY account 
            ORDER BY year_established DESC, revenue DESC
        ) AS rn
    FROM bronze_accounts
    WHERE account IS NOT NULL
) AS sub
WHERE rn = 1;

SELECT * FROM silver_accounts;
DROP TABLE silver_accounts;