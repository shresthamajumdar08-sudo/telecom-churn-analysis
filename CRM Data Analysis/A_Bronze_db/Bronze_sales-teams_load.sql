LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CRM Dataset\\sales_teams.csv'
INTO TABLE bronze_sales_teams
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@sales_agent, @manager, @regional_office)
SET
    sales_agent = NULLIF(TRIM(@sales_agent), ''),
    manager = NULLIF(TRIM(@manager), ''),
    regional_office = NULLIF(TRIM(@regional_office), '');
