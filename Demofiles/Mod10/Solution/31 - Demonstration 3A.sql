-- Demonstration 3A

-- Step 1 - Open a new query window against the AdventureWorks database

USE AdventureWorks;
GO

-- Step 2 - Use the code from the earlier slide to create a table-valued function

CREATE FUNCTION Sales.GetLastOrdersForCustomer 
(@CustomerID int, @NumberOfOrders int)
RETURNS TABLE
AS
RETURN (SELECT TOP(@NumberOfOrders)
                              soh.SalesOrderID,
                              soh.OrderDate,
                              soh.PurchaseOrderNumber
                FROM Sales.SalesOrderHeader AS soh
                WHERE soh.CustomerID = @CustomerID
                ORDER BY soh.OrderDate DESC
               );
GO

-- Step 3 - Query that function. It will return the last two 
--          orders for customer 17288.

SELECT * FROM Sales.GetLastOrdersForCustomer(17288,2);
GO

-- Step 4 - Now show how CROSS APPLY could be used to call this 
--          function (note that many students will not be familiar 
--          with CROSS APPLY so you might wish to review its use, 
--          particularly in relation to table-valued functions
--          Note as a matter of interest that if you scroll to 
--          customer 11012, you will see a customer with less than
--          three orders. The function will still return these customers.

SELECT c.CustomerID,
             c.AccountNumber,
             glofc.SalesOrderID,
             glofc.OrderDate 
FROM Sales.Customer AS c
CROSS APPLY Sales.GetLastOrdersForCustomer(c.CustomerID,3) AS glofc
ORDER BY c.CustomerID,glofc.SalesOrderID;

-- Step 5 - Drop the function

DROP FUNCTION Sales.GetLastOrdersForCustomer;
GO