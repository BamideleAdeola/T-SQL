
ALTER DATABASE Triga MODIFY NAME = Triga_db;
GO  

USE Triga_db;
GO

USE master;
GO

disable trigger tr_recorder on all server;

  EXEC sp_rename 'dbo.discounts.column1', 'Customer', 'COLUMN';
  EXEC sp_rename 'dbo.discounts.column2', 'Discount', 'COLUMN';
/* BUILDING AND OPTIMIZING TRIGGERS IN SQL SERVER */
--------------------------------------------------

/*INTRODUCTION*/

/*
Create a new trigger on the Discounts table.
Use the trigger to prevent DELETE statements.
*/

-- Create a new trigger that fires when deleting data
CREATE TRIGGER PreventDiscountsDelete
ON Discounts
-- The trigger should fire instead of DELETE
INSTEAD OF DELETE
AS
	PRINT 'You are not allowed to delete data from the Discounts table.';


/*
Create the new trigger for the Orders table.
Set the trigger to be fired only after UPDATE statements.
*/

-- Set up a new trigger
CREATE TRIGGER OrdersUpdatedRows
ON Orders
-- The trigger should fire after UPDATE statements
AFTER UPDATE
-- Add the AS keyword before the trigger body
AS
	-- Insert details about the changes to a dedicated table
	INSERT INTO OrdersUpdate(OrderID, OrderDate, ModifyDate)
	SELECT OrderID, OrderDate, GETDATE()
	FROM inserted;

/*
DML TRIGGERS USAGE

WHY triggers
-----
1. Initiating actions while manipulating data
2. Preventing data manipulation
3. Tracking data or database object changes
4. User auditing and database security
one needs to know the difference between the 
AFTER and INSTEAD OF types of trigger.
*/

CREATE TRIGGER SalesNewInfoTrigger
ON sales
AFTER INSERT
AS
EXEC sp_cleaning @Table = 'Sales';
EXEC sp_generateSalesReport;
EXEC sp_sendnotification;


/*Creating a trigger to keep track of data changes

Create the ProductsNewItems trigger on the Products table.
Set the trigger to fire when data is inserted into the table.

*/

-- Create a new trigger
CREATE TRIGGER ProductsNewItems
ON Products
AFTER INSERT
AS
	-- Add details to the history table
	INSERT INTO ProductsHistory(Product, Price, Currency, FirstAdded)
	SELECT Product, Price, Currency, GETDATE()
	FROM inserted;


/* Triggers vs. stored procedures
Run an update on the Discounts table (this will fire the CustomerDiscountHistory trigger).
Get all the rows from DiscountsHistory to verify the outcome.

*/
-- Run an update for some of the discounts
UPDATE discounts
SET Discount = Discount + 1
WHERE Discount <= 5;

-- Verify the trigger ran successfully
SELECT * FROM DiscountsHistory;


/* Triggers vs. computed columns
Insert new data into SalesWithPrice and then run a SELECT from the 
same table to verify the outcome.

*/
-- Add the following rows to the table
INSERT INTO SalesWithPrice (Customer, Product, Price, Currency, Quantity)
VALUES ('Fruit Mag', 'Pomelo', 1.12, 'USD', 200),
	   ('VitaFruit', 'Avocado', 2.67, 'USD', 400),
	   ('Tasty Fruits', 'Blackcurrant', 2.32, 'USD', 1100),
	   ('Health Mag', 'Kiwi', 1.42, 'USD', 100),
	   ('eShop', 'Plum', 1.1, 'USD', 500);

-- Verify the results after adding the new rows
SELECT * FROM SalesWithPrice;


/*
Insert new data into SalesWithoutPrice and then run a SELECT 
from the same table to verify the outcome.
*/

-- Add the following rows to the table
INSERT INTO SalesWithoutPrice (Customer, Product, Currency, Quantity)
VALUES ('Fruit Mag', 'Pomelo', 'USD', 200),
	   ('VitaFruit', 'Avocado', 'USD', 400),
	   ('Tasty Fruits', 'Blackcurrant', 'USD', 1100),
	   ('Health Mag', 'Kiwi', 'USD', 100),
	   ('eShop', 'Plum', 'USD', 500);

-- Verify the results after the INSERT
SELECT * FROM SalesWithoutPrice;



			------------------------------------
			--CHAPTER 2 CLASSIFICATION OF TRIGGERS
			------------------------------------

/* Tracking retired products
Create the TrackRetiredProducts trigger on the Products table.
Set the trigger to fire after rows are deleted from the table.
*/
-- Create the trigger
CREATE TRIGGER TrackRetiredProducts
ON Products
AFTER DELETE
AS
	INSERT INTO RetiredProducts (Product, Measure)
	SELECT Product, Measure
	FROM deleted;


/* The TrackRetiredProducts trigger in action
Remove retired items from the Products table and check the 
output from the RetiredProducts table.
*/
-- Remove the products that will be retired
DELETE FROM Products
WHERE Product IN ('Cloudberry', 'Guava', 'Nance', 'Yuzu');

-- Verify the output of the history table
SELECT * FROM RetiredProducts;



/*
You have been given the task to create new triggers on some tables, 
with the following requirements:

Keep track of canceled orders (rows deleted from the Orders table). 
Their details will be kept in the table CanceledOrders upon removal.

Keep track of discount changes in the table Discounts. Both the old 
and the new values will be copied to the DiscountsHistory table.

Send an email to the Sales team via the SendEmailtoSales stored 
procedure when a new order is placed.

*/

-- Create a new trigger for canceled orders
CREATE TRIGGER KeepCanceledOrders
ON orders
AFTER DELETE
AS 
	INSERT INTO CanceledOrders
	SELECT * FROM deleted;

/*
Create a new trigger on the Discounts table to keep track of discount value changes.
*/
-- Create a new trigger to keep track of discounts
CREATE TRIGGER CustomerDiscountHistory
ON Discounts
AFTER UPDATE
AS
	-- Store old and new values into the `DiscountsHistory` table
	INSERT INTO DiscountsHistory (Customer, OldDiscount, NewDiscount, ChangeDate)
	SELECT i.Customer, d.Discount, i.Discount, GETDATE()
	FROM inserted AS i
	INNER JOIN deleted AS d ON i.Customer = d.Customer;

/*
Create the trigger NewOrderAlert to notify the Sales team when new orders are placed.
*/

-- Notify the Sales team of new orders
CREATE TRIGGER NewOrderAlert
ON Orders
AFTER INSERT
AS
	EXECUTE SendEmailtoSales;


-----------
--INSTEAD OF TRIGGER - DML
-------------
/* Preventing changes to orders

Create a new trigger on the Orders table.
Set the trigger to prevent updates and return an error message instead.

*/
-- Create the trigger
CREATE TRIGGER PreventOrdersUpdate
ON Orders
INSTEAD OF UPDATE
AS
	RAISERROR ('Updates on "Orders" table are not permitted.
                Place a new order to add new products.', 16, 1);


/* Creating the PreventNewDiscounts trigger
Create the trigger PreventNewDiscounts on the Discounts table.
Set the trigger to prevent any rows being added to the Discounts table.
*/

-- Create a new trigger
CREATE TRIGGER PreventNewDiscounts
ON Discounts
INSTEAD OF INSERT
AS
	RAISERROR ('You are not allowed to add discounts for existing customers.
                Contact the Sales Manager for more details.', 16, 1);


--DDL TRIGGERS
/* Tracking table changes

You need to create a new trigger at the database level that logs 
modifications to the table TablesChangeLog.

The trigger should fire when tables are created, modified, or deleted.
*/

-- Create the trigger to log table info
CREATE TRIGGER TrackTableChanges
ON DATABASE
FOR CREATE_TABLE,
	ALTER_TABLE,
	DROP_TABLE
AS
	INSERT INTO TablesChangeLog (EventData, ChangedBy)
    VALUES (EVENTDATA(), USER);


/* Preventing table deletion
Fresh Fruit Delivery wants to prevent its regular employees 
from deleting tables from the database.
------

Create a new trigger, PreventTableDeletion, to prevent table deletion.
The trigger should roll back the firing statement, so the 
deletion does not happen.
*/

-- Add a trigger to disable the removal of tables
CREATE TRIGGER PreventTableDeletion
ON DATABASE
FOR DROP_TABLE
AS
	RAISERROR ('You are not allowed to remove tables from this database.', 16, 1);
    ROLLBACK;


-------------
--LOGON TRIGGER
------------
-- CAN ONLY BE ATTACHED AT THE SERVER LEVEL

CREATE TRIGGER logonAudit
ON ALL SERVER WITH EXECUTE AS 'sa'
FOR LOGON
AS 
	INSERT INTO ServerLogonLog
				(LoginName, LoginDate, SessionID, SourceIPAddress)
	SELECT ORIGINAL_LOGIN(), GETDATE(), @@SPID, client_net_address
	FROM SYS.DM_EXEC_CONNECTIONS WHERE session_id = @@SPID; 


/* Enhancing database security
Create the INSERT statement that is going to fill 
in user details in the ServerLogonLog table.

Select only the details for the situation when the session_id is the same 
as the @@SPID (ID of the current user).
*/

-- Save user details in the audit table
INSERT INTO ServerLogonLog (LoginName, LoginDate, SessionID, SourceIPAddress)
SELECT ORIGINAL_LOGIN(), GETDATE(), @@SPID, client_net_address
-- The user details can be found in SYS.DM_EXEC_CONNECTIONS
FROM SYS.DM_EXEC_CONNECTIONS WHERE session_id = @@SPID;

/*
Create a new trigger at the server level that fires for logon events 
and saves user details into ServerLogonLog table.
*/

-- Create a trigger firing when users log on to the server
CREATE TRIGGER LogonAudit
-- Use ALL SERVER to create a server-level trigger
ON ALL SERVER WITH EXECUTE AS 'sa'
-- The trigger should fire after a logon
AFTER LOGON
AS
	-- Save user details in the audit table
	INSERT INTO ServerLogonLog (LoginName, LoginDate, SessionID, SourceIPAddress)
	SELECT ORIGINAL_LOGIN(), GETDATE(), @@SPID, client_net_address
	FROM SYS.DM_EXEC_CONNECTIONS WHERE session_id = @@SPID;


			---------------------------------------------
			--CHAPTER 3 TRIGGER LIMITATIONS AND USE CASES
			---------------------------------------------

/* Merit of triggers
1. Used for database integrity
2. Enforce business rules directly in the database
3. Control on which data are allowed in a database
4. Implementation of complex business logic triggered by a single event
5. Simple way to audit databases and user actions

Demerit of triggers
1. Difficult to view and detect 
2. Invincible to client applications or when debugging code
3. Hard to follow their logic when troubleshooting
4. Can become an overhead on the server and make it run slower
*/

-- TO retrieve server level triggers
SELECT * FROM sys.server_triggers;

 CREATE TRIGGER tr_logon_CheckIP  
 ON ALL SERVER  
 FOR LOGON  
 AS
 BEGIN
  IF IS_SRVROLEMEMBER ( 'sysadmin' ) = 1  
     BEGIN
         DECLARE @IP NVARCHAR ( 15 );  
         SET @IP = ( SELECT EVENTDATA ().value ( '(/EVENT_INSTANCE/ClientHost)[1]' , 'NVARCHAR(15)' ));  
         IF NOT EXISTS( SELECT IP FROM DBAWork.dbo.ValidIP WHERE IP = @IP )  
         ROLLBACK ;  
     END ;  
 END ;  
 GO

 SELECT * FROM sys.triggers;


 /* Creating a report on existing triggers
 Start creating the triggers report by gathering information about existing 
 database triggers from the sys.triggers table.
 */

 -- Get the column that contains the trigger name
SELECT name AS TriggerName,
	   parent_class_desc AS TriggerType,
	   create_date AS CreateDate,
	   modify_date AS LastModifiedDate,
	   is_disabled AS Disabled,
       -- Get the column that tells if it's an INSTEAD OF trigger
	   is_instead_of_trigger AS InsteadOfTrigger
FROM sys.triggers;


/*
Include information about existing server-level triggers from the 
sys.server_triggers table and order by trigger name.
*/

-- Gather information about database triggers
SELECT name AS TriggerName,
	   parent_class_desc AS TriggerType,
	   create_date AS CreateDate,
	   modify_date AS LastModifiedDate,
	   is_disabled AS Disabled,
	   is_instead_of_trigger AS InsteadOfTrigger
FROM sys.triggers
UNION ALL
SELECT name AS TriggerName,
	   -- Get the column that contains the trigger type
	   parent_class_desc AS TriggerType,
	   create_date AS CreateDate,
	   modify_date AS LastModifiedDate,
	   is_disabled AS Disabled,
	   0 AS InsteadOfTrigger
-- Gather information about server triggers
FROM sys.server_triggers
-- Order the results by the trigger name
ORDER BY TriggerName;


/*
Enhance the report by including the trigger definitions. You can get a 
trigger's definition using the OBJECT_DEFINITION function.

*/

-- Gather information about database triggers
SELECT name AS TriggerName,
	   parent_class_desc AS TriggerType,
	   create_date AS CreateDate,
	   modify_date AS LastModifiedDate,
	   is_disabled AS Disabled,
	   is_instead_of_trigger AS InsteadOfTrigger,
       -- Get the trigger definition by using a function
	   OBJECT_DEFINITION (object_id)
FROM sys.triggers
UNION ALL
-- Gather information about server triggers
SELECT name AS TriggerName,
	   parent_class_desc AS TriggerType,
	   create_date AS CreateDate,
	   modify_date AS LastModifiedDate,
	   is_disabled AS Disabled,
	   0 AS InsteadOfTrigger,
       -- Get the trigger definition by using a function
	   OBJECT_DEFINITION (object_id)
FROM sys.server_triggers
ORDER BY TriggerName;


/*
Keeping a history of row changes
The Fresh Fruit Delivery company needs to track changes made to the Customers table.

You are asked to create a new trigger that covers any statements modifying rows in the table
-----

Create a new trigger called CopyCustomersToHistory.
Attach the trigger to the Customers table.
Fire the trigger when rows are added or modified.
Extract the information from the inserted special table.

*/


-- Create a trigger to keep row history
CREATE TRIGGER CopyCustomersToHistory
ON Customers
-- Fire the trigger for new and updated rows
AFTER INSERT, UPDATE
AS
	INSERT INTO CustomersHistory (CustomerID, Customer, ContractID, ContractDate, Address, PhoneNo, Email, ChangeDate)
	SELECT CustomerID, Customer, ContractID, ContractDate, Address, PhoneNo, Email, GETDATE()
    -- Get info from the special table that keeps new rows
    FROM inserted;



/*
Table auditing using triggers
The company has decided to keep track of changes made to all the most important tables. One of those tables is Orders.

Any modification made to the content of Orders should be inserted into TablesAudit.
----------
Create a new AFTER trigger on the Orders table.
Set the trigger to fire for INSERT, UPDATE, and DELETE statements.

*/

-- Add a trigger that tracks table changes
CREATE TRIGGER OrdersAudit
ON Orders
AFTER INSERT, UPDATE, DELETE
AS
	DECLARE @Insert BIT = 0;
	DECLARE @Delete BIT = 0;	
	IF EXISTS (SELECT * FROM inserted) SET @Insert = 1;
	IF EXISTS (SELECT * FROM deleted) SET @Delete = 1;
	INSERT INTO TablesAudit (TableName, EventType, UserAccount, EventDate)
	SELECT 'Orders' AS TableName
	       ,CASE WHEN @Insert = 1 AND @Delete = 0 THEN 'INSERT'
				 WHEN @Insert = 1 AND @Delete = 1 THEN 'UPDATE'
				 WHEN @Insert = 0 AND @Delete = 1 THEN 'DELETE'
				 END AS Event
		   ,ORIGINAL_LOGIN() AS UserAccount
		   ,GETDATE() AS EventDate;



/*
Preventing changes to Products
The Fresh Fruit Delivery company doesn't want regular users to be able to change product information or the actual stock.
-----------

Create a new trigger, PreventProductChanges, that prevents any updates to the Products table.

*/

-- Prevent any product changes
CREATE TRIGGER PreventProductChanges
ON Products
INSTEAD OF UPDATE
AS
	RAISERROR ('Updates of products are not permitted. Contact the database administrator if a change is needed.', 16, 1);



/* Checking stock before placing orders
On multiple occasions, customers have placed orders for products when the company didn't have enough stock to fulfill the orders.

This issue can be easily fixed by adding a new trigger with conditional logic for its actions.

The trigger should fire when new rows are added to the Orders table and check if the company has sufficient stock of the specified products to fulfill those orders.

If there is sufficient stock, the trigger will then perform the same INSERT operation like the one that fired it—only this time, the values will be taken from the inserted special table.
---------

Add a new trigger that fires for INSERT statements and checks if the order quantity can be fulfilled by the current stock.
Raise an error if there's insufficient stock. Otherwise, perform an INSERT by making use of the inserted special table.
*/

-- Create a new trigger to confirm stock before ordering
CREATE TRIGGER ConfirmStock
ON Orders
INSTEAD OF INSERT
AS
	IF EXISTS (SELECT *
			   FROM Products AS p
			   INNER JOIN inserted AS i ON i.Product = p.Product
			   WHERE p.Quantity < i.Quantity)
	BEGIN
		RAISERROR ('You cannot place orders when there is no stock for the product.', 16, 1);
	END
	ELSE
	BEGIN
		INSERT INTO Orders (OrderID, Customer, Product, Price, Currency, Quantity, WithDiscount, Discount, OrderDate, TotalAmount, Dispatched)
		SELECT OrderID, Customer, Product, Price, Currency, Quantity, WithDiscount, Discount, OrderDate, TotalAmount, Dispatched FROM inserted;
	END;



/*
TRIGGERS AT DDL LEVEL - CREATED AT SERVER AND DATABASE LEVEL
*/

--DATABASE AUDIT

/*
Create a DatabaseAudit trigger on the database that fires for DDL_TABLE_VIEW_EVENTS.
*/

-- Create a new trigger
CREATE TRIGGER DatabaseAudit
-- Attach the trigger at the database level
ON DATABASE
-- Fire the trigger for all tables/ views events
FOR DDL_TABLE_VIEW_EVENTS
AS
	-- Add details to the specified table
	INSERT INTO DatabaseAudit (EventType, DatabaseName, SchemaName, Object, ObjectType, UserAccount, Query, EventTime)
	SELECT EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(50)') AS EventType
		  ,EVENTDATA().value('(/EVENT_INSTANCE/DatabaseName)[1]', 'NVARCHAR(50)') AS DatabaseName
		  ,EVENTDATA().value('(/EVENT_INSTANCE/SchemaName)[1]', 'NVARCHAR(50)') AS SchemaName
		  ,EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)') AS Object
		  ,EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'NVARCHAR(50)') AS ObjectType
		  ,EVENTDATA().value('(/EVENT_INSTANCE/LoginName)[1]', 'NVARCHAR(100)') AS UserAccount
		  ,EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)') AS Query
		  ,EVENTDATA().value('(/EVENT_INSTANCE/PostTime)[1]', 'DATETIME') AS EventTime;



/* Preventing server changes
Create a new trigger called PreventDatabaseDelete.
Attach the trigger at the server level.
*/

-- Create a trigger to prevent database deletion
CREATE TRIGGER PreventDatabaseDelete
-- Attach the trigger at the server level
ON ALL SERVER
FOR DROP_DATABASE
AS
   PRINT 'You are not allowed to remove existing databases.';
   ROLLBACK;


/*
Modify the trigger definition and fix the typo without dropping and recreating the trigger.
Add the missing word to the PRINT statement.

*/

-- Fix the typo in the trigger message
ALTER TRIGGER PreventDiscountsDelete
ON Discounts
INSTEAD OF DELETE
AS
	PRINT 'You are not allowed to remove data from the Discounts table.';



/*
Pause the trigger execution to allow the company to make the changes.
*/

-- Pause the trigger execution
DISABLE TRIGGER PreventOrdersUpdate
ON Orders;


/* Re-enabling a disabled trigger

Re-enable the disabled PreventOrdersUpdate trigger attached to the Orders table.
*/

-- Resume the trigger execution
ENABLE TRIGGER PreventOrdersUpdate
ON Orders;


/* Managing existing triggers

1. Get the name, object_id, and parent_class_desc for all the disabled triggers.
*/

--1 Get the disabled triggers
SELECT name,
	   object_id,
	   parent_class_desc
FROM sys.triggers
WHERE is_disabled = 1;



/*Get the unmodified server-level triggers.
An unmodified trigger's create date is the same as the modify date.*/

-- Check for unchanged server triggers
SELECT *
FROM sys.server_triggers
WHERE create_date = modify_date;


/*
Use sys.triggers to extract information only about database-level triggers.
*/
-- Get the database triggers
SELECT *
FROM sys.triggers
WHERE parent_class_desc = 'DATABASE';



/* Keeping track of trigger executions
Modify the PreventOrdersUpdate trigger.
Set the trigger to fire when rows are updated in the Orders table.
Add additional details about the trigger execution into the TriggerAudit table.
*/

-- Modify the trigger to add new functionality
ALTER TRIGGER PreventOrdersUpdate
ON Orders
-- Prevent any row changes
INSTEAD OF UPDATE
AS
	-- Keep history of trigger executions
	INSERT INTO TriggerAudit (TriggerName, ExecutionDate)
	SELECT 'PreventOrdersUpdate', 
           GETDATE();

	RAISERROR ('Updates on "Orders" table are not permitted.
                Place a new order to add new products.', 16, 1);



SELECT t.name AS TriggerName,
	   OBJECT_DEFINITION(t.object_id) AS TriggerDefinition
FROM sys.objects AS o
INNER JOIN sys.triggers AS t ON t.parent_id = o.object_id
INNER JOIN sys.trigger_events AS te ON te.object_id = t.object_id
WHERE o.name = 'Orders'
AND te.type_desc = 'UPDATE';