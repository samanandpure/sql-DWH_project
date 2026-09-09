/*
created the insert statement for the silver.crm_cust_info
prior to inserting Checked the whether duplictes are there based on the primary key, distinct values on gender & maritual status
converted them into full like for gender if it M then male, for status if its s meanse single like wise
using the Row_number window fnction inserted the records which are only having row_num 1 for cst_id


after inserting the daa checked the same issues are persisting for silver table or not
not seeing any issue
*/

--find dups based on the PK
select cst_id, count(*)
from bronze.crm_cust_info
group by cst_id
having count(*) > 1;

--check the unwanted space
select cst_firstname
from bronze.crm_cust_info
where cst_firstname != TRIM(cst_firstname);
select cst_lastname
from bronze.crm_cust_info
where cst_lastname != TRIM(cst_lastname);

--standardization of data
select distinct (cst_marital_status) from bronze.crm_cust_info;
select distinct(cst_gndr) from bronze.crm_cust_info;

insert into silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)
select 
	cst_id,
	cst_key,
	TRIM (cst_firstname), 
	TRIM (cst_lastname) ,
	case 
		when TRIM(upper(cst_marital_status)) = 'M' then 'married'
		when TRIM(upper(cst_marital_status)) = 'S' then 'single'
	    else 'n/a'
	end as cst_marr_cnst,
	case 
		when TRIM(upper(cst_gndr)) = 'F' then 'female'
		when TRIM(upper(cst_gndr)) = 'M' then 'male'
		else 'n/a'
	end as cst_gndr_cn,
	cst_create_date
from (
select
	*,
	ROW_NUMBER() over (partition by cst_id order by cst_create_date) as rn
from 
	bronze.crm_cust_info) t
where rn = 1;



--find dups based on the PK
select cst_id, count(*)
from silver.crm_cust_info
group by cst_id
having count(*) > 1;

--check the unwanted space
select cst_firstname
from silver.crm_cust_info
where cst_firstname != TRIM(cst_firstname);
select cst_lastname
from silver.crm_cust_info
where cst_lastname != TRIM(cst_lastname);

--standardization of data
select distinct (cst_marital_status) from silver.crm_cust_info;
select distinct(cst_gndr) from silver.crm_cust_info;
