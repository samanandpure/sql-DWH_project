/*
*/
insert into silver.crm_prd_info (
	prd_id ,
	cat_id ,
	prd_key ,
	prd_nm ,
	prd_cost ,
	prd_line ,
	prd_start_dt,
	prd_end_dt
)
select 
	prd_id,
	SUBSTRING (prd_key,1,5) as cat_id,
	REPLACE (SUBSTRING(prd_key,7,len(prd_key)),'-','_'),
	TRIM(prd_nm),
	ISNULL(prd_cost,0) as prd_cost,
	CASE TRIM(UPPER(prd_line))
WHEN 'M' THEN 'Mountain'
WHEN 'R' THEN 'Road'
WHEN 'S' THEN 'Other Sales'
WHEN 'T' THEN 'Touring'
ELSE 'N/A'
	END AS prd_line,
CAST(prd_start_dt as DATE) as prd_start_dt,
CAST(((lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)) - 1) as date) as prd_end_dt
from bronze.crm_prd_info;
