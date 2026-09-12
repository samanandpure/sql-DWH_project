/*
*/


insert into silver.erp_cust_az12 (
    CID,
    BDATE,
    GEN
)
select
    CASE 
        WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4,len(CID))
        else CID
    END AS CID,
    CASE 
        WHEN BDATE > GETDATE() THEN NULL
        ELSE BDATE
    END AS BDATE,
    CASE
        WHEN UPPER(TRIM(gen)) in ('F','FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) in ('M','MALE') THEN 'Male'
        ELSE 'n/a'
    END AS gen
from 
    bronze.erp_cust_az12;
