LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CRM Dataset\\data_dictionary.csv'
INTO TABLE bronze_data_dictionary
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@table_name, @field, @description)
SET
    table_name = NULLIF(TRIM(@table_name), ''),
    field = NULLIF(TRIM(@field), ''),
    description = NULLIF(TRIM(@description), '');   