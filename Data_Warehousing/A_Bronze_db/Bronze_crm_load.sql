LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Data_Warehousing\\Dataset\\source_crm\\cust_info.csv'
INTO TABLE Bronze_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@cst_id, @cst_key, @cst_firstname, @cst_lastname,
 @cst_marital_status, @cst_gndr, @cst_create_date)
SET
    cst_id = NULLIF(TRIM(@cst_id), ''),
    cst_key = NULLIF(TRIM(@cst_key), ''),
    cst_firstname = NULLIF(TRIM(@cst_firstname), ''),
    cst_lastname = NULLIF(TRIM(@cst_lastname), ''),
    cst_marital_status = NULLIF(TRIM(@cst_marital_status), ''),
    cst_gndr = NULLIF(TRIM(@cst_gndr), ''),
    cst_create_date = NULLIF(TRIM(@cst_create_date), '');
    

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Data_Warehousing\\Dataset\\source_crm\\prd_info.csv'
INTO TABLE bronze_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@prd_id, @prd_key, @prd_nm, @prd_cost,
 @prd_line, @prd_start_dt, @prd_end_dt)
SET
    prd_id = NULLIF(TRIM(@prd_id), ''),
    prd_key = NULLIF(TRIM(@prd_key), ''),
    prd_nm = NULLIF(TRIM(@prd_nm), ''),
    prd_cost = NULLIF(TRIM(@prd_cost), ''),
    prd_line = NULLIF(TRIM(@prd_line), ''),
    prd_start_dt = NULLIF(TRIM(@prd_start_dt), ''),
    prd_end_dt = NULLIF(TRIM(@prd_end_dt), '');

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Data_Warehousing\\Dataset\\source_crm\\sales_details.csv'
INTO TABLE bronze_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@sls_ord_num, @sls_prd_key, @sls_cust_id,
 @sls_order_dt, @sls_ship_dt, @sls_due_dt,
 @sls_sales, @sls_quantity, @sls_price)
SET
    sls_ord_num = NULLIF(TRIM(@sls_ord_num), ''),
    sls_prd_key = NULLIF(TRIM(@sls_prd_key), ''),
    sls_cust_id = NULLIF(TRIM(@sls_cust_id), ''),
    sls_order_dt = NULLIF(TRIM(@sls_order_dt), ''),
    sls_ship_dt = NULLIF(TRIM(@sls_ship_dt), ''),
    sls_due_dt = NULLIF(TRIM(@sls_due_dt), ''),
    sls_sales = NULLIF(TRIM(@sls_sales), ''),
    sls_quantity = NULLIF(TRIM(@sls_quantity), ''),
    sls_price = NULLIF(TRIM(@sls_price), '');
    