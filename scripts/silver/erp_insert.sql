/*
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
