/*========================================
     Assignment   : Lab-03_Chapter-03
     Due          : 2/15/2021 @ 11:59pm
     Points       : 10 pts each = 50pts
     Author       : Will Beck
==========================================*/
USE AP
GO

/*=========================================================================================== Q1 (7 rows):
     Write a query that returns the InvoiceNumber and the days from the invoice date 
     to the payment date (named DaysPassed) as long as it is 40 or more days. Order
     the list by the DaysPassed from highest to lowest. Actual output below:

          InvoiceNumber    DaysPassed
          77290            52
          75C-90227        49
          121897           44
          RTR-72-3662-X    44
          24946731         40
          109596           40
          25022117         40

*/
    SELECT  InvoiceNumber,
            [DaysPassed] = DATEDIFF(day, InvoiceDate, PaymentDate)
    FROM Invoices
    WHERE DATEDIFF(day, InvoiceDate, PaymentDate) >= 40
    ORDER BY DaysPassed DESC

     

/*=========================================================================================== Q2 (10 rows):
     Write a query that returns a list of the states that have invoices. Return the state
     only and order by the state ( No join statements allowed. Use a sub-query ). Actual
     output below:

          VendorState
          AZ
          CA
          DC
          MA
          MI
          NV
          OH
          PA
          TN
          TX
*/
    SELECT VendorState
    FROM Vendors
    WHERE VendorID IN (
        SELECT DISTINCT VendorID FROM Invoices
    )
    GROUP BY VendorState

/*=========================================================================================== Q3 (5 rows):
     Write a query that returns the top 5 vendors with the highest total invoices (i.e.,
     all invoices summed up). Return the VendorID, TotalInvoices, and the InvoiceCount.
     Actual output below:

     VendorID     TotalInvoices     InvoiceCount
        110          119892.41         5
        122          23177.96          9
        72           21927.31          2
        104          7125.34           1
        99           6940.25           1
*/
    SELECT TOP(5)
        VendorID,
        [TotalInvoice] = SUM(InvoiceTotal),
        [InvoiceCount] = COUNT(*)
    FROM Invoices
    GROUP BY VendorID 
    ORDER BY TotalInvoice DESC

/*=========================================================================================== Q4 (2 rows):
     Write a query that will return a list of Vendors that have:
     > An 800 number
     > The first number of their zipcode is  from 1 to 5
     > The second number of their zipcode is from 3 to 5
     > The last number of their zipcode is a 5

     Include columns: VendorName, VendorPhone, and VendorZipCode
     Actual output below:

          VendorName                      VendorPhone        VendorZipCode
          Publishers Weekly               (800) 555-1669     43305
          Champion Printing Company       (800) 555-1957     45225
*/

     SELECT   
            VendorName,
            VendorPhone,
            VendorZipCode
     FROM Vendors
     WHERE (VendorPhone LIKE '(800)%') AND
           (VendorZipCode LIKE '[1-5][3-5]%5')

/*=========================================================================================== Q5 (44 rows):
     Write a query that returns all vendors that have a PO Box. Note, there are many forms
     that are listed (e.g., PO Box, P O Box, P.O. Box, etc.) so you should only look for Box.
     > Exclude all records that do not have a phone number.
     > Return VendorName, VendorAddress1, VendorAddress2, and VendorPhone.
     > Do not show NULLs for any of the fields. You should account for NULLS being in 
       VendorAddress1 and VendorAddress2
     > Sort the list by VendorName

     First 5 rows listed below:

          VendorName                     VendorAddress1             VendorAddress2               VendorPhone
          American Express               Box 0001                                                (800) 555-3344
          BFI Industries                 PO Box 9369                                             (559) 555-1551
          Blue Cross                     PO Box 9061                                             (800) 555-0912
          Blue Shield of California      PO Box 7021                                             (415) 555-5103
          Cahners Publishing Company     Citibank Lock Box 4026     8725 W Sahara Zone 1127      (301) 555-2162
*/

     SELECT    VendorName,
               [VendorAddress1] = ISNULL(VendorAddress1, ' '),
               [VendorAddress2] = ISNULL(VendorAddress2, ' '),
               VendorPhone
     FROM Vendors
     WHERE 
          (VendorPhone LIKE IS NOT NULL) AND    
          (VendorAddress1 LIKE ('%Box%') OR VendorAddress2 LIKE ('%Box%'))           
     ORDER BY VendorName






