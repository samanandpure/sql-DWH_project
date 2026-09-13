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


/*
In Table  bronze.erp_loc_a101
The column CID was having '-' in between this column we have to connect with cst_key there '-' was no there so we removed that
CNTRY column having some irreularaties so we replaced with proper values

*/

insert into silver.erp_loc_a101 (
	CID,
	CNTRY)
select
	replace(CID,'-','') as CID,
	CASE
		WHEN TRIM(CNTRY) in ('US','USA') THEN 'United States'
		WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
		WHEN TRIM(CNTRY) is Null or TRIM(CNTRY) = '' THEN 'n/a'
		ELSE TRIM(CNTRY)
	END AS CNTRY
from bronze.erp_loc_a101;

/*
The data was clean in bronze.erp_px_cat_g1v2 the data does not needed to be cleaned so we loaded the data as it
*/
insert into silver.erp_px_cat_g1v2 (id,cat,subcat,maintenance)
select id,cat,subcat,maintenance
from  bronze.erp_px_cat_g1v2;
