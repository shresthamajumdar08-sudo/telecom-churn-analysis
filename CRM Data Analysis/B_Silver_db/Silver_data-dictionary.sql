CREATE TABLE silver_data_dictionary (
    table_name VARCHAR(50),
    field VARCHAR(50),
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (table_name, field)
);


INSERT INTO silver_data_dictionary (
    table_name,
    field,
    description
)
SELECT 
    CONCAT(
        UPPER(LEFT(COALESCE(table_name, 'Unknown'), 1)),
        LOWER(SUBSTRING(COALESCE(table_name, 'Unknown'), 2))
    ) AS table_name,
    CONCAT(
        UPPER(LEFT(COALESCE(field, 'Unknown'), 1)),
        LOWER(SUBSTRING(COALESCE(field, 'Unknown'), 2))
    ) AS field,
    CONCAT(
        UPPER(LEFT(COALESCE(description, 'No Description Available'), 1)),
        LOWER(SUBSTRING(COALESCE(description, 'No Description Available'), 2))
    ) AS description
FROM (
    SELECT 
        table_name,
        field,
        description,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(table_name), TRIM(field) 
            ORDER BY description DESC
        ) AS rn
    FROM bronze_data_dictionary
    WHERE table_name IS NOT NULL 
      AND field IS NOT NULL
) AS sub
WHERE rn = 1;

SELECT * FROM silver_data_dictionary;

