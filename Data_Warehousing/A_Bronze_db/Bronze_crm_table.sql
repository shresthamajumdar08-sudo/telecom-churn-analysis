CREATE TABLE bronze_cust_info(
    cst_id INT, 
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(10),
    cst_gndr VARCHAR(10),
    cst_create_date DATE
);
CREATE TABLE bronze_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost INT,
    prd_line VARCHAR(10),
    prd_start_dt DATE,
    prd_end_dt DATE
);

CREATE TABLE bronze_sales_details (
    sls_ord_num VARCHAR(10),
    sls_prd_key VARCHAR(20),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);