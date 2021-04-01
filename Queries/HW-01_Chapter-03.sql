/*
    CSE 385
    Homework-01
    5 points each question
    Author: Will Beck
*/
/*================================================================================ Q1: Returns 122 Records
    Write a SELECT statement that returns 3 columns from the Vendors table:
    VendorContactFName, VendorContactLName, and VendorName. 
    Sort the result set by the last name, then by first name
*/
SELECT VendorContactFName, VendorContactLName, VendorName
FROM Vendors
ORDER BY VendorContactLName, VendorContactFName 


/*================================================================================ Q2  Returns 114 Records
    Write a SELECT statement that returns the following 4 columns from the Invoice table:
        number        alias for InvoiceNumber
        total        alias for InvoiceTotal 
        credits        PaymentTotal + CreditTotal
        balance        InvoiceTotal - PaymentTotal - CreditTotal
    use "Old-School" notation for assigning the column aliases
*/
SELECT      InvoiceNumber AS [number],
            InvoiceTotal AS [tota],
            ( PaymentTotal + CreditTotal ) AS [credits],
            ( InvoiceTotal - PaymentTotal - CreditTotal ) AS [balance] 
FROM    Invoices


/*================================================================================ Q3: Returns 122 Records
    Write a SELECT statement that returns one column from the Vendors table: fullName.
    Create this column from the VendorContactFName and VendorContactLName columns.
    Format it as last name, first name (ex: Stahr, Michael) Sort the set by last name
    then first name.
*/
SELECT      [fullName] = CONCAT( VendorContactLName,', ', VendorContactFName)
FROM Vendors
ORDER BY VendorContactLName, VendorContactFName


/*================================================================================ Q4: Returns 2 Records
    Write a SELECT statement that returns 3 columns:
        invoiceTotal    From the Invoices table
        interest        10% of the value of InvoiceTotal
        grandTotal      InvoiceTotal + the interest
    Where the balance is more than 1,000
*/
SELECT      InvoiceTotal,
            [interest] = (0.10 * InvoiceTotal),
            [grandTotal] = (InvoiceTotal + (0.10 * InvoiceTotal) )
FROM Invoices
WHERE (InvoiceTotal - PaymentTotal - CreditTotal) > 1000



/*================================================================================ Q5: Returns 33  Records
    Write the same query from question #2 but modify the query to filter for invoices with 
    an InvoiceTotal that's greater than or equal to 500 but less than or equal to 10000
*/
SELECT      [number]    = InvoiceNumber,
            [tota]      = InvoiceTotal,
            [credits]   = ( PaymentTotal + CreditTotal ),
            [balance]   = ( InvoiceTotal - PaymentTotal - CreditTotal ) 
FROM    Invoices
WHERE InvoiceTotal BETWEEN 500 AND 10000



/*================================================================================ Q6: Returns 41  Records
    Write the same query from question #3 but modify the query to filter for contacts 
    whose last name begins with the letter A, B, C, or E
*/
SELECT      [fullName] = CONCAT( VendorContactLName,', ', VendorContactFName)
FROM Vendors
WHERE VendorContactLName LIKE '[ABCE]%'
ORDER BY VendorContactLName, VendorContactFName




/*================================================================================ Q7: Returns 0  Records
    Write a SELECT statement that determines whether the PaymetDate column of the Invoices
    table has any invalid values. To be valid, PaymentDate must be a null value if there's a
    balance due and a non-null value if there's no balance due. Code a compound condition in
    the WHERE clause that tests for these conditions.
*/
SELECT PaymentDate
FROM Invoices
WHERE   ( ( PaymentDate IS NULL ) AND ( ( InvoiceTotal - PaymentTotal - CreditTotal ) > 0 ) ) OR
        ( ( PaymentDate IS NOT NULL ) AND ( ( InvoiceTotal - PaymentTotal - CreditTotal ) IS NULL ) )
