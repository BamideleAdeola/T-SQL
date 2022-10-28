------------------------------
-- VARIABLES 
------------------------------

-- Variables are needed to set values. e.g DECLARE @variablename data_type
-- It must start with @ character
-- Most common data types are VARCHAR, INT and DECIMAL or NUMERIC

/* Q1
Write a T-SQL query which will return the sum of the Quantity column as Total for each type of MixDesc.
*/

-- Declare Snack as a variable with a VARCHAR length 10 character
DECLARE @Snack VARCHAR(10)

-- Assigning cariables
DECLARE @Snack VARCHAR(10)
SET @Snack = 'Cookies'
SELECT @Snack;

   -- OR

DECLARE @Snack VARCHAR(10)
SELECT @Snack = 'Candy'
SELECT @Snack;


			---------------------------------
					--  WHILE LOOP --
			---------------------------------
/*
While evaluates a true or false condition
After the while, there should be a line with the keyword BEGIN
Then include the code to include within the while condition
After which you should add END
BREAK will cause an exit of the loop
CONTINUE will cause the loop to continue

*/

--Declare the variable ctr
DECLARE @ctr INT
--Assign it with SET to 1
SET @ctr = 1
-- Specify condition of the While Loop
WHILE @ctr < 10
	BEGIN
		SET @ctr = @ctr + 1
	END
SELECT @ctr;



/*
1. Create an integer variable named counter.
Assign the value 20 to this variable.

2. Increment the variable counter by 1 and assign it back to counter.

3. Write a WHILE loop that increments counter by 1 until counter is less than 30.
*/

DECLARE @counter INT 
SET @counter = 20
-- Create a loop
WHILE @counter < 30
-- Loop code starting point
BEGIN
	SELECT @counter = @counter + 1
-- Loop finish
END
-- Check the value of the variable
SELECT @counter AS myvar;