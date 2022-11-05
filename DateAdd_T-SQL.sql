
SELECT 
  DATEADD(day, 45, getdate()) AS FourtyFiveDaysFromNow; -- 45 Days from today is 2022-12-18 07:53:30.110
GO
SELECT 
    Orderid,
	OrderDate,
	DATEADD(DAY, 20, OrderDate) As ProposedShipeddate, -- 20 Days plus OrderDate
	ShippedDate,
	DATEDIFF(DAY, DATEADD(DAY, 20, OrderDate), ShippedDate) AS DaysDue
FROM dbo.orders;
GO