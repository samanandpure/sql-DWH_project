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



/*
*/

insert into silver.crm_sales_details (
    sls_ord_num ,
	sls_prd_key ,
	sls_cust_id ,
	sls_order_dt ,
	sls_ship_dt ,
	sls_due_dt ,
	sls_sales ,
	sls_quantity ,
	sls_price 

)
select
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    case 
        when sls_order_dt < 0 or len(sls_order_dt) != 8 then null
        else cast(cast(sls_order_dt as varchar) as date)
    end as sls_order_dt,
    case 
        when sls_ship_dt < 0 or len(sls_ship_dt) != 8 then null
        else cast(cast(sls_ship_dt as varchar) as date)
    end as sls_ship_dt,
    case 
        when sls_due_dt < 0 or len(sls_due_dt) != 8 then null
        else cast(cast(sls_due_dt as varchar) as date)
    end as sls_due_dt,
    case 
        when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price) then sls_quantity * ABS(sls_price)
        else sls_sales
    end as sls_sales,
    sls_quantity,
    case 
        when sls_price is null or sls_price <= 0 then sls_sales/ nullif (sls_quantity,0)
        else sls_price
    end as sls_price
from
    bronze.crm_sales_details;


