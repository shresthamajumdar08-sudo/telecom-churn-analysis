LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CRM Dataset\\sales_pipeline.csv'
INTO TABLE bronze_sales_pipeline
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@opportunity_id, @sales_agent, @product, @account,
 @deal_stage, @engage_date, @close_date, @close_value)
SET
    opportunity_id = NULLIF(TRIM(@opportunity_id), ''),
    sales_agent = NULLIF(TRIM(@sales_agent), ''),
    product = NULLIF(TRIM(@product), ''),
    account = NULLIF(TRIM(@account), ''),
    deal_stage = NULLIF(TRIM(@deal_stage), ''),
    engage_date = NULLIF(TRIM(@engage_date), ''),
    close_date = NULLIF(TRIM(@close_date), ''),
    close_value = NULLIF(TRIM(@close_value), '');
