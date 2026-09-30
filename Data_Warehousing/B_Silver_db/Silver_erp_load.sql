TRUNCATE TABLE silver_CUST_AZ12;
INSERT INTO silver_CUST_AZ12(
    CID,
    BDATE,
    GEN
)
SELECT 
    CASE
    WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
    ELSE CID
END AS CID,
    CASE
    WHEN BDATE > CURRENT_DATE() THEN NULL
    ELSE BDATE
END AS BDATE,
CASE
    WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
    WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
    ELSE 'n/a'
END AS GEN 
FROM bronze_cust_az12;


TRUNCATE TABLE silver_LOC_A101;
INSERT INTO silver_loc_a101 (cid, cntry)
SELECT 
    REPLACE(cid, '-', '') AS cid,                               
    CASE 
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry
FROM bronze_loc_a101;
SELECT * FROM silver_LOC_A101;

TRUNCATE TABLE silver_PX_CAT_G1V2;
INSERT INTO silver_PX_CAT_G1V2 (id, cat, subcat, maintenance)
SELECT 
    TRIM(id) AS id,
    TRIM(cat) AS cat,
    TRIM(subcat) AS subcat,
    CASE 
        WHEN TRIM(maintenance) = 'YES' THEN 'Yes'
        WHEN TRIM(maintenance) = 'NO' THEN 'No'
        ELSE 'n/a'
    END AS maintenance
FROM bronze_px_cat_g1v2; 

SELECT * FROM silver_PX_CAT_G1V2;