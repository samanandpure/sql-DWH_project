/*
creates the datawarehouse databse
Then we have created the 3 schemas
bronze
silver
gold*/
use master;

create database DataWarehouse;

use DataWarehouse;

create schema bronze;
create schema silver;
go
create schema gold;
go
