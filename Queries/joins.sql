--============================================ The Implicit Join
/*
    -- VendorName, InvoiceNumber, InvoiceTotal 
    SELECT  v.VendorID,
            v.VendorName,
            InvoiceNumber, InvoiceTotal
    FROM Vendors     v,
         Invoices    i
    WHERE v.VendorID = i.VendorID

    -- VendorName, InvoiceNumber, InvoiceTotal, Balence (if balance > 0)
    SELECT  v.VendorName,
            i.Balance,
            i.InvoiceNumber,
            i.InvoiceTotal
    FROM Vendors     v,
         vwInvoices    i
    WHERE   (v.VendorID = i.VendorID) AND
            (i.Balance > 0)

     -- VendorName, InvoiceNumber, InvoiceLineItemDescription, InvoiceLineItemAmount
    SELECT  v.VendorName,
            i.InvoiceNumber,
            ili.InvoiceLineItemDescription,
            ili.InvoiceLineItemAmount
    FROM Vendors            v,
         Invoices           i,
         InvoiceLineItems   ili
    WHERE (v.VendorID = i.InvoiceID) AND
          (i.InvoiceID = ili.InvoiceID)


--============================================ The Explicit Join

        -- VendorName, InvoiceNumber, InvoiceTotal 
    SELECT  v.VendorID,
            v.VendorName,
            InvoiceNumber, InvoiceTotal
    FROM Vendors     v 
        JOIN Invoices i ON v.VendorID = i.VendorID

    -- VendorName, InvoiceNumber, InvoiceTotal, Balence (if balance > 0)
    SELECT  v.VendorName,
            i.Balance,
            i.InvoiceNumber,
            i.InvoiceTotal
    FROM Vendors     v
        JOIN vwInvoices i ON (v.VendorID = i.VendorID)
    WHERE (i.Balance > 0)
    ORDER BY v.VendorName

    -- VendorName, InvoiceNumber, InvoiceLineItemDescription, InvoiceLineItemAmount
    SELECT  v.VendorName,
            i.InvoiceNumber,
            ili.InvoiceLineItemDescription,
            ili.InvoiceLineItemAmount
    FROM Vendors v 
            JOIN Invoices i             ON v.VendorID = i.VendorID
            JOIN InvoiceLineItems ili   ON i.InvoiceID = ili.InvoiceID

    -- Self join that returns vendors from cities in common with other vendors

    SELECT DISTINCT v1.VendorName, v1.VendorCity, v1.VendorState
    FROM Vendors v1
        JOIN Vendors v2 ON
            (v1.VendorCity = v2.VendorCity)     AND 
            (v1.VendorState = v2.VendorState)   AND
            (v1.VendorID <> v2.VendorID)
    ORDER BY v1.VendorState, v1.VendorCity

    -- VendorName, CustLastName, CustFirstName, VendorState, VendorCity
    SELECT  VendorName,
            CustLastName,
            CustFirstName,
            VendorState,
            VendorCity
    FROM AP..Vendors v 
        JOIN ProductOrders..Customers c ON v.VendorZipCode = c.CustZip
    ORDER BY VendorState, VendorCity
    
    */

    SELECT *
    FROM Vendors v 
        FULL JOIN ContactUpdates c ON v.VendorID = c.VendorID