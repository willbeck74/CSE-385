/*
    Basic List              Advanced List 
    ----------              -------------
    SELECT                  SELECT
    FROM                    FROM
    WHERE                   WHERE
    ORDER BY                GROUP BY
                            HAVING
                            ORDER BY
                            OFFSET

=========================================================
SELECT *
FROM Vendors
WHERE VendorState = 'NY'

SELECT *
FROM Vendors
WHERE (VendorPhone IS NULL) AND (VendorAddress1 IS NULL)

SELECT *
FROM Vendors
WHERE (VendorState = 'NY') OR (VendorState = 'NJ')

SELECT *
FROM Vendors
WHERE ( VendorState IN ('NY', 'NJ') )

SELECT *
FROM Vendors
WHERE VendorState LIKE 'N[YJ]' 

SELECT *
FROM Vendors
WHERE VendorZipCode LIKE '%18'

--EXAM QUESTION 9, 5 ends in 1, 2, 3
SELECT *
FROM Vendors
WHERE VendorZipCode LIKE '[95]%[123]' 
ORDER BY VendorZipCode

SELECT InvoiceNumber,
        [Balance] = (InvoiceTotal - PaymentTotal - CreditTotal)
FROM Invoices
WHERE (VendorID = 123) AND 
      (InvoiceTotal - PaymentTotal - CreditTotal) > 0
ORDER BY Balance

SELECT  VendorID,
        [Balance] = SUM(InvoiceTotal - PaymentTotal - CreditTotal),
        [InvoiceCount] = COUNT(*)
FROM Invoices
WHERE (InvoiceTotal) >= 100
GROUP BY VendorID
HAVING SUM(InvoiceTotal - PaymentTotal - CreditTotal) > 0

SELECT  *
FROM Invoices
WHERE ( InvoiceTotal >= 100 ) AND
      ( InvoiceTotal <= 200 )

SELECT  *
FROM Invoices
WHERE ( InvoiceTotal BETWEEN 100 AND 200 )

SELECT *
FROM Invoices
WHERE ( InvoiceDate BETWEEN '2016-01-01' AND '2016-05-31')

-- Version #1
    Select DISTINCT VendorState
    From Vendors
    ORDER BY VendorState

-- Version #2
    SELECT  VendorState
    FROM Vendors
    GROUP BY VendorState
    ORDER BY VendorState

SELECT TOP(10) WITH TIES
    VendorID,
    VendorCity,
    VendorState
FROM Vendors
ORDER BY VendorState

SELECT  '(' + CAST(VendorID AS VARCHAR(5)) + ')' + VendorName,
        VendorCity + ', ' + VendorState AS [Location]
FROM Vendors

SELECT  '(' + CONVERT( VARCHAR(5), VendorID ) + ')' + VendorName,
        VendorCity + ', ' + VendorState AS [Location]
FROM Vendors

SELECT  [VendorName]    = CONCAT( '(' ,  VendorID  , ')' , VendorName ) ,
        [Location]      = CONCAT( VendorCity , ', ' , VendorState)
FROM Vendors
*/

SELECT  300/4.2 AS num1,
        10989 * 1.12 AS total

