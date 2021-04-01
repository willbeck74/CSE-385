/* ---------------------------------------------------------------------- Q2
    Write a query that returns list of customers and how much they have
    spent in orders and how many orders they have. Return the CustID, a 
    field called TotalAmountPaid, and a field called TotalOrders. Order 
    the list by the CustID.

        First 5 Rows:
        -------------
        1    114.30   3
        2    76.90    4
        3    34.90    2
        4    13.00    1
        5    17.95    1
*/
USE ProductOrders
    SELECT  CustID,
            [TotalAmountPaid]   = SUM(od.Quantity * i.UnitPrice),
            [TotalOrders]       = COUNT(DISTINCT o.OrderID)
    FROM Orders o 
        JOIN OrderDetails od ON o.OrderID = od.OrderID
        JOIN Items i ON od.ItemID = i.ItemID
    GROUP BY o.CustID
    ORDER BY CustID

SELECT o.*
FROM Orders o
    LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE od.OrderID IS NULL --o.OrderID NOT IN (SELECT DISTINCT OrderID FROM OrderDetails)

/* ---------------------------------------------------------------------- Q4
    Write a query that retuns the top 3 sales reps with the most total 
    sales Return first name, last name and the total sales called TotalSales

    Result:
    ----------------------------------
    Jonathon    Thomas        3196940.69
    Sonja       Martinez      2841015.55
    Andrew       Markasian    2165620.04
*/
USE Examples

    SELECT TOP(3)
        sr.RepFirstName,
        sr.RepLastName,
        [TotalSales] = SUM(SalesTotal)
    FROM SalesReps sr 
        JOIN SalesTotals st ON sr.RepID = st.RepID
    GROUP BY sr.RepID, sr.RepFirstName, sr.RepLastName
    ORDER BY TotalSales DESC

/*********************************************************
    Rules for UNION
        1.  Each result set must return the same number of columns
        2.  Corresponding columns must have compatible data types
        3. Column names are taken from the first SELECT
        4. ORDER BY can only order by fields in query
    
1    [Status]: Warning, Send Collection Notice, Cancel Account, Paid
2    Balance     1-99        100-500             >500            0
3    InvoiceNumber

Order by VendorID

*/
----------------------------------------------------------------------
USE AP
-- CTE = Common Table Expression
GO
WITH tbl AS (
        SELECT  [Status] = 'Warning'
                ,Balance
                ,InvoiceNumber
        FROM vwInvoices
        WHERE Balance BETWEEN 1 AND  99
    UNION
        SELECT  [Status] = 'Send Collection Notice'
                ,Balance
                ,InvoiceNumber
        FROM vwInvoices
        WHERE Balance BETWEEN 100 AND  500
    UNION
        SELECT  [Status] = 'Cancel Account'
                ,Balance
                ,InvoiceNumber
        FROM vwInvoices
        WHERE Balance > 500
    UNION
        SELECT  [Status] = 'Paid'
                ,Balance
                ,InvoiceNumber
        FROM vwInvoices
        WHERE Balance = 0
)   SELECT v.VendorID, v.VendorContactFName, v.VendorContactLName, tbl.* 
    FROM tbl
        JOIN vwInvoices i   ON tbl.InvoiceNumber = i.InvoiceNumber
        JOIN Vendors v      ON i.VendorID = v.VendorID

/*
    Return a list of every Vendor and the number of invoices they have
    Return the VendorName and [InvoiceCount]
*/

SELECT  v.VendorName
        ,[InvoiceCount] = COUNT(i.InvoiceID) 
FROM Vendors v
    LEFT JOIN Invoices i ON v.VendorID = i.VendorID
GROUP BY VendorName
ORDER BY InvoiceCount DESC

USE Examples

    SELECT CustomerFirst, CustomerLast
    FROM Customers
EXCEPT
    SELECT FirstName, LastName
    FROM Employees

    SELECT FirstName, LastName
    FROM Employees
EXCEPT
    SELECT CustomerFirst, CustomerLast
    FROM Customers


GO

WITH tbl as(
     SELECT FirstName, LastName
    FROM Employees
INTERSECT
    SELECT CustomerFirst, CustomerLast
    FROM Customers
) SELECT e.*
  FROM tbl JOIN Employees e ON  tbl.FirstName   = e.FirstName AND
                                tbl.LastName    = e.LastName

    SELECT EmployeeID, LastName FROM Employees
UNION ALL -- keeps duplicates, regular union removes duplicates
    SELECT EmployeeID, LastName FROM Employees