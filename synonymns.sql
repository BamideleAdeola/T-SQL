


/*Create a synonym prod for [TestOrders].[dbo].[products_t], 
insert into the synonym and confirm the iserted values in products_t table*/

USE TestOrders;
GO

CREATE SYNONYM Prod 
FOR [TestOrders].[dbo].[products_t]
GO

-- Insert values into the synonym [Prod] 

INSERT INTO Prod
VALUES ( 6, 'Blade', 32);

-- To confirm if the update reflects on product table

SELECT * FROM products_t;