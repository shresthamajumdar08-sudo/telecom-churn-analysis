LOAD DATA INFILE'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CRM Dataset\\products.csv'
INTO TABLE bronze_products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@product, @series, @sales_price)
SET
    product = NULLIF(TRIM(@product), ''),
    series = NULLIF(TRIM(@series), ''),
    sales_price = NULLIF(TRIM(@sales_price), '');
    