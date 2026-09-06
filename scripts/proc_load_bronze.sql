/*
Stored procedure will truncate the table & then inserts the records into it
it will also give us the how much amount of time taken by each table to load the data & for whole batch of data

To execute the sproc or to load the data 

EXEC bronze.load_bronze;  

*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS 
BEGIN
	BEGIN TRY
		DECLARE @start_time datetime, @end_time as datetime, @batch_start_time datetime, @batch_end_time datetime 
		print '============';
		print 'data insertion for table:  bronze.crm_cust_info';
		set @batch_start_time = GETDATE();
		set @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;

		BULK INSERT bronze.crm_cust_info
		from 'C:\Users\satis\Desktop\sam\DATA Warehouse project\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		set @end_time = getdate();
		print 'load duration: ' + cast(datediff(second, @start_time,@end_time) AS VARCHAR) + '   seconds';
		print '============';


		print '============';
		print 'data insertion for table:  bronze.crm_prd_info';
		set @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		from 'C:\Users\satis\Desktop\sam\DATA Warehouse project\source_crm\prd_info.csv'
		with (
			firstrow=2,
			fieldterminator = ',',
			tablock
		);

		set @end_time = getdate();
		print 'load duration: ' + cast(datediff(second, @start_time,@end_time) AS VARCHAR) + '   seconds';
		print '============';


		print '============';
		print 'data insertion for table:  bronze.crm_prd_info';
		set @start_time = GETDATE();

		TRUNCATE TABLE bronze.crm_sales_details;

		BULK INSERT bronze.crm_sales_details
		from 'C:\Users\satis\Desktop\sam\DATA Warehouse project\source_crm\sales_details.csv'
		with (
		 firstrow = 2,
		 fieldterminator = ',',
		 tablock
		);

		set @end_time = getdate();

		print 'load duration: ' + cast(datediff(second, @start_time,@end_time) AS VARCHAR) + '   seconds';
		print '============';



		print '============';
		print 'data insertion for table:  bronze.crm_prd_info';
		set @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_cust_az12;

		bulk insert bronze.erp_cust_az12
		from 'C:\Users\satis\Desktop\sam\DATA Warehouse project\source_erp\CUST_AZ12.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);

		set @end_time = getdate();

		print 'load duration: ' + cast(datediff(second, @start_time,@end_time) AS VARCHAR) + '   seconds';
		print '============';



		print '============';
		print 'data insertion for table:  bronze.crm_prd_info';

		set @start_time = GETDATE();

		TRUNCATE TABLE bronze.erp_loc_a101;

		BULK INSERT bronze.erp_loc_a101
		from 'C:\Users\satis\Desktop\sam\DATA Warehouse project\source_erp\LOC_A101.csv'
		with(
			firstrow=2,
			fieldterminator=',',
			tablock
		);

		set @end_time = getdate();
		print 'load duration: ' + cast(datediff(second, @start_time,@end_time) AS VARCHAR) + '   seconds';
		print '============';

		print '============';
		print 'data insertion for table:  bronze.crm_prd_info';

		set @start_time = GETDATE();

		TRUNCATE TABLE  bronze.erp_px_cat_g1v2;

		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\satis\Desktop\sam\DATA Warehouse project\source_erp\PX_CAT_G1V2.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			tablock
		);

		set @end_time = getdate();
		set @batch_end_time = getdate();

		print 'load duration: ' + cast(datediff(second, @start_time,@end_time) AS VARCHAR) + '   seconds';

		print 'load duration for whole batch insertion: ' + cast(datediff(second, @batch_start_time, @batch_end_time) AS VARCHAR) + '  seconds';
		print '============';

	END TRY
	BEGIN CATCH
		print 'error occured while loading data into bronze layer';
		print 'error message' + error_message() ;
		print 'error state' + cast(error_state() as varchar);
		print 'error num' + cast(error_number() as varchar)
	END CATCH
END;



