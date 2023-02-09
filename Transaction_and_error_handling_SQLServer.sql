
-- Set up the TRY block
BEGIN TRY
	-- Add the constraint
	ALTER TABLE products
		ADD CONSTRAINT CHK_Stock CHECK (stock >= 0);
END TRY
-- Set up the CATCH block
BEGIN CATCH
	SELECT 'An error occurred!';
END CATCH



/* CHALLENGE
Surround the INSERT INTO buyers statement with a TRY block.
Surround the error handling with a CATCH block.
Surround the INSERT INTO errors statement with another TRY block.
Surround the nested error handling with another CATCH block.

*/

-- Set up the first TRY block
BEGIN TRY
	INSERT INTO buyers (first_name, last_name, email, phone)
		VALUES ('Peter', 'Thompson', 'peterthomson@mail.com', '555000100');
END TRY
-- Set up the first CATCH block
BEGIN CATCH
	SELECT 'An error occurred inserting the buyer! You are in the first CATCH block';
    -- Set up the nested TRY block
    BEGIN TRY
    	INSERT INTO errors 
        	VALUES ('Error inserting a buyer');
        SELECT 'Error inserted correctly!';
    END TRY    
    -- Set up the nested CATCH block
    BEGIN CATCH
    	SELECT 'An error occurred inserting the error! You are in the nested CATCH block';
    END CATCH    
END CATCH



/*
Note: Error messages in DataCamp have different anatomy than in SQL Server, 
but as they show the error message, you won't have any problem.

Run the code to verify there are compilation errors.
Correct every compilation error.
Run the code to get the final output: An error occurred inserting the product!
*/

BEGIN TRY
	INSERT INTO products (product_name, stock, price)
		VALUES ('Sun Bicycles ElectroLite - 2017', 10, 1559.99);
END TRY
BEGIN CATCH
	SELECT 'An error occurred inserting the product!';
    BEGIN TRY
    	INSERT INTO errors 
        	VALUES ('Error inserting a product');
    END TRY    
    BEGIN CATCH
    	SELECT 'An error occurred inserting the error!';
    END CATCH    
END CATCH



/*
Surround the operation with a TRY block.
Surround the functions with a CATCH block.
Select the error information.
*/

-- Set up the TRY block
BEGIN TRY  	
	SELECT 'Total: ' + SUM(price * quantity) AS total
	FROM orders  
END TRY
-- Set up the CATCH block
BEGIN CATCH  
	-- Show error information.
	SELECT  ERROR_NUMBER() AS number,  
        	ERROR_SEVERITY() AS severity_level,  
        	ERROR_STATE() AS state,
        	ERROR_LINE() AS line,  
        	ERROR_MESSAGE() AS message; 	
END CATCH 

---------------------------------------------------------------

BEGIN TRY
    INSERT INTO products (product_name, stock, price) 
    VALUES	('Trek Powerfly 5 - 2018', 2, 3499.99),   		
    		('New Power K- 2018', 3, 1999.99)		
END TRY
-- Set up the outer CATCH block
BEGIN CATCH
	SELECT 'An error occurred inserting the product!';
    -- Set up the inner TRY block
    BEGIN TRY
    	-- Insert the error
    	INSERT INTO errors 
        	VALUES ('Error inserting a product');
    END TRY    
    -- Set up the inner CATCH block
    BEGIN CATCH
    	-- Show number and message error
    	SELECT 
        	ERROR_LINE() AS line,	   
			ERROR_MESSAGE() AS message; 
    END CATCH    
END CATCH



DECLARE @product_id INT = 5;

IF NOT EXISTS (SELECT * FROM products WHERE product_id = @product_id)
	-- Invoke RAISERROR with parameters
	RAISERROR('No product with id %d.', 11, 1, @product_id);
ELSE 
	SELECT * FROM products WHERE product_id = @product_id;


	BEGIN TRY
    DECLARE @product_id INT = 5;
    IF NOT EXISTS (SELECT * FROM products WHERE product_id = @product_id)
        RAISERROR('No product with id %d.', 11, 1, @product_id);
    ELSE 
        SELECT * FROM products WHERE product_id = @product_id;
END TRY
-- Catch the error
BEGIN CATCH
	-- Select the error message
	SELECT ERROR_MESSAGE();
END CATCH    


/*
Surround the error handling with a CATCH block.
Insert the error in the errors table.
End the insert statement with a semicolon (;).
Re-throw the original error.
*/

CREATE PROCEDURE insert_product
  @product_name VARCHAR(50),
  @stock INT,
  @price DECIMAL

AS

BEGIN TRY
	INSERT INTO products (product_name, stock, price)
		VALUES (@product_name, @stock, @price);
END TRY
-- Set up the CATCH block
BEGIN CATCH	
	-- Insert the error and end the statement with a semicolon
    INSERT INTO errors VALUES ('Error inserting a product');  
    -- Re-throw the error
	THROW;  
END CATCH

/*
Execute the stored procedure called insert_product.
Set the appropriate values for the parameters of the stored procedure.
Surround the error handling with a CATCH block.
Select the error message.
*/

BEGIN TRY
	-- Execute the stored procedure
	EXEC insert_product
    	-- Set the values for the parameters
    	@product_name = 'Trek Conduit+',
        @stock = 50,
        @price = 100;
END TRY
-- Set up the CATCH block
BEGIN CATCH
	-- Select the error message
	SELECT ERROR_MESSAGE();
END CATCH


/*
Use the THROW statement, with 50001 as the error number, 'No staff member with such id' as the message text, and 1 as the state.
Replace the value of @staff_id in the DECLARE statement at the beginning with an identifier that doesn't exist (e.g. '45') and click Run Code (not Run Solution). You will see the error.
Set the value of @staff_id back to 4 and run the code without errors.
*/
DECLARE @staff_id INT = 4;

IF NOT EXISTS (SELECT * FROM staff WHERE staff_id = @staff_id)
   	-- Invoke the THROW statement with parameters
	THROW 50001, 'No staff member with such id', 1;
ELSE
   	SELECT * FROM staff WHERE staff_id = @staff_id;


SELECT * FROM sys.messages;

----------------------------------------------
--CUSTOMIZING ERROR MESSAGES IN THROW STATEMENT
-----------------------------------------------

/*
Assign to @my_message the concatenation of 'There is no staff member with ', with the value of @first_name and with ' as the first name.'.
Use THROW with 50000 as the error number, @my_message as the message parameter, and 1 as the state.
Replace the name 'Pedro' in the DECLARE statement at the beginning with a name that doesn't exist (e.g. 'David') and click Run Code (not Run Solution). You will see the error.
Change again 
*/

DECLARE @first_name NVARCHAR(20) = 'Pedro';

-- Concat the message
DECLARE @my_message NVARCHAR(500) =
	CONCAT('There is no staff member with ', @first_name, ' as the first name.');

IF NOT EXISTS (SELECT * FROM staff WHERE first_name = @first_name)
	-- Throw the error
	THROW 50000, @my_message, 1;


/*
Set @sold_bikes to a value greater than @current_stock (e.g. 100).
Customize the error using FORMATMESSAGE with the text 'There are not enough %s bikes. You have %d in stock.' as the first parameter, @product_name as the second parameter, and @current_stock as the third parameter.
Pass to the THROW statement the @my_message variable and click Run Code (not Run Solution). You will see the error.
Set @sold_bikes in DECLARE statement back to 10. Run the code without errors.
*/
DECLARE @product_name AS NVARCHAR(50) = 'Trek CrossRip+ - 2018';
-- Set the number of sold bikes
DECLARE @sold_bikes AS INT = 10;
DECLARE @current_stock INT;

SELECT @current_stock = stock FROM products WHERE product_name = @product_name;

DECLARE @my_message NVARCHAR(500) =
	-- Customize the error message
	FORMATMESSAGE('There are not enough %s bikes. You have %d in stock.', @product_name, @current_stock);




IF (@current_stock - @sold_bikes < 0)
	-- Throw the error
	THROW 50000, @my_message, 1;


/*
TRANSACTIONS AND ROLLBACK
*/

BEGIN TRY  
	BEGIN TRAN;
		UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
		INSERT INTO transactions VALUES (1, -100, GETDATE());
        
		UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
		INSERT INTO transactions VALUES (5, 100, GETDATE());
	BEGIN TRAN;
END TRY
BEGIN CATCH  
	ROLLBACK TRAN;
END CATCH


/*
Begin the transaction.
Correct the mistake in the operation.
Commit the transaction if there are no errors.
Inside the CATCH block, roll back the transaction.
*/

BEGIN TRY  
	-- Begin the transaction
	BEGIN TRAN;
		UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
		INSERT INTO transactions VALUES (1, -100, GETDATE());
        
		UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
        -- Correct it
		INSERT INTO transactions VALUES (5, 100, GETDATE());
    -- Commit the transaction
	COMMIT TRAN;    
END TRY
BEGIN CATCH  
	SELECT 'Rolling back the transaction';
    -- Rollback the transaction
	ROLLBACK TRAN;
END CATCH


/*
Begin the transaction.
Check if the number of affected rows is bigger than 200.
Rollback the transaction if the number of affected rows is more than 200.
Commit the transaction if the number of affected rows is less than or equal to 200.
*/

-- Begin the transaction
BEGIN TRAN; 
	UPDATE accounts set current_balance = current_balance + 100
		WHERE current_balance < 5000;
	-- Check number of affected rows
	IF @@ROWCOUNT > 200 
		BEGIN 
        	-- Rollback the transaction
			ROLLBACK TRAN; 
			SELECT 'More accounts than expected. Rolling back'; 
		END
	ELSE
		BEGIN 
        	-- Commit the transaction
			COMMIT TRAN; 
			SELECT 'Updates commited'; 
		END


------------------------------------------
--@@TRANCOUNT AND SAVEPOINTS
------------------------------------------

/*
Begin the transaction.
Correct the mistake in the operation.
Inside the TRY block, check if there is a transaction and commit it.
Inside the CATCH block, check if there is a transaction and roll it back.
*/

BEGIN TRY
	-- Begin the transaction
	BEGIN TRAN;
    	-- Correct the mistake
		UPDATE accounts SET current_balance = current_balance + 200
			WHERE account_id = 10;
    	-- Check if there is a transaction
		IF @@TRANCOUNT > 0     
    		-- Commit the transaction
			COMMIT TRAN;
     
	SELECT * FROM accounts
    	WHERE account_id = 10;      
END TRY
BEGIN CATCH  
    SELECT 'Rolling back the transaction'; 
    -- Check if there is a transaction
    IF @@TRANCOUNT > 0   	
    	-- Rollback the transaction
        ROLLBACK TRAN;
END CATCH

-------------------------------
-- USING SAVEPOINTS
------------------------------
BEGIN TRAN;
	-- Mark savepoint1
	SAVE TRAN savepoint1 ;
	INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');

	-- Mark savepoint2
    SAVE TRAN savepoint2 ;
	INSERT INTO customers VALUES ('Zack', 'Roberts', 'zackroberts@mail.com', '555919191');

	-- Rollback savepoint2
	ROLLBACK TRAN savepoint2 ;
    -- Rollback savepoint1
	ROLLBACK TRAN savepoint1 ;

	-- Mark savepoint3
	SAVE TRAN savepoint3 ;
	INSERT INTO customers VALUES ('Jeremy', 'Johnsson', 'jeremyjohnsson@mail.com', '555929292');
-- Commit the transaction
COMMIT TRAN;


----------------------------
--XACT_ABORT & XACT_STATE
----------------------------

/*
Use the appropriate setting of XACT_ABORT.
Begin the transaction.
If the number of affected rows is less than or equal to 10, throw the error using the THROW statement, with a number of 55000.
Commit the transaction if the number of affected rows is more than 10.
*/
-- Use the appropriate setting
SET XACT_ABORT ON;
BEGIN TRY
	BEGIN TRAN;
		INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');
		INSERT INTO customers VALUES ('Dylan', 'Smith', 'dylansmith@mail.com', '555888999');
	COMMIT TRAN;
END TRY
BEGIN CATCH
	-- Check if there is an open transaction
	IF XACT_STATE() <> 0
    	-- Rollback the transaction
		ROLLBACK TRAN;
    -- Select the message of the error
    SELECT ERROR_MESSAGE() AS Error_message;
END CATCH

-- Use the appropriate setting
SET XACT_ABORT ON;
-- Begin the transaction
BEGIN TRAN; 
	UPDATE accounts set current_balance = current_balance - current_balance * 0.01 / 100
		WHERE current_balance > 5000000;
	IF @@ROWCOUNT <= 10	
    	-- Throw the error
		THROW 55000, 'Not enough wealthy customers!', 1;
	ELSE		
    	-- Commit the transaction
		COMMIT TRAN; 


/*
Use the appropriate setting of XACT_ABORT.
Check if there is an open transaction.
Rollback the transaction.
Select the error message.
*/
-- Use the appropriate setting
SET XACT_ABORT ON;
BEGIN TRY
	BEGIN TRAN;
		INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');
		INSERT INTO customers VALUES ('Dylan', 'Smith', 'dylansmith@mail.com', '555888999');
	COMMIT TRAN;
END TRY
BEGIN CATCH
	-- Check if there is an open transaction
	IF XACT_STATE() <> 0
    	-- Rollback the transaction
		ROLLBACK TRAN;
    -- Select the message of the error
    SELECT ERROR_MESSAGE() AS Error_message;
END CATCH


--------------------------------
-- TRANSACTION ISOLATION LEVELS
-------------------------------

/*
Set the READ UNCOMMITTED isolation level.
Select first_name, last_name, email and phone from customers table.
*/

-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- Select first_name, last_name, email and phone
	SELECT
    	first_name, 
        last_name, 
        email, 
        phone
    FROM customers;


/*
Set the appropriate isolation level to prevent dirty reads.
Select the count of accounts that match the criteria.
*/

-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- Count the accounts
SELECT COUNT(*) AS number_of_accounts
FROM accounts
WHERE current_balance >= 50000;


/* PREVENTING NON-REPEATABLE READS
Set the appropriate isolation level to prevent non-repeatable reads.
Begin a transaction.
Commit the transaction.
*/

-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
-- Begin a transaction
BEGIN TRAN
SELECT * FROM customers;
-- some mathematical operations, don't care about them...
SELECT * FROM customers;
-- Commit the transaction
COMMIT TRAN


/*
Set the appropriate isolation level to prevent phantom reads.
Begin the transaction.
Commit the transaction.
*/

-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

-- Begin a transaction
BEGIN TRAN

SELECT * FROM customers;

-- After some mathematical operations, we selected information from the customers table.
SELECT * FROM customers;

-- Commit the transaction
COMMIT TRAN


/*
Set the appropriate isolation level to prevent phantom reads.
Begin a transaction.
Select those customers you want to lock.
Commit the transaction.
*/

-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
-- Begin a transaction
BEGIN TRAN
-- Select customer_id between 1 and 10
SELECT * 
FROM customers
WHERE customer_id BETWEEN 1 AND 10;

-- After completing some mathematical operation, select customer_id between 1 and 10
SELECT * 
FROM customers
WHERE customer_id BETWEEN 1 AND 10;
-- Commit the transaction
COMMIT TRAN


------------
-- SNAPSHOT
-----------

/*
Change your script to avoid being blocked.
*/
SELECT *
	-- Avoid being blocked
	FROM transactions WITH (NOLOCK)
WHERE account_id = 1