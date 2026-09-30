LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CRM Dataset\\accounts.csv'
INTO TABLE bronze_accounts
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@account, @sector, @year_established,
 @revenue, @employees, @office_location,
 @subsidiary_of)
SET
    account = NULLIF(TRIM(@account), ''),
    sector = NULLIF(TRIM(@sector), ''),
    year_established = NULLIF(TRIM(@year_established), ''),
    revenue = NULLIF(TRIM(@revenue), ''),
    employees = NULLIF(TRIM(@employees), ''),
    office_location = NULLIF(TRIM(@office_location), ''),
    subsidiary_of = NULLIF(TRIM(@subsidiary_of), '');