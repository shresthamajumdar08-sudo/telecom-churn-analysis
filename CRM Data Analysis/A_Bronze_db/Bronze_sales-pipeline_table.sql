CREATE TABLE bronze_sales_pipeline (
    opportunity_id VARCHAR(50),
    sales_agent VARCHAR(50),
    product VARCHAR(50),
    account VARCHAR(50),
    deal_stage VARCHAR(50),
    engage_date DATE,
    close_date DATE,
    close_value DECIMAL(10,2)
);