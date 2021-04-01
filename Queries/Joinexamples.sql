/*
    2021-02-18
    Chapter 4 - Part II


USE AP

-------------------------------------------------------------- Left Join (All) / Left "outer" join
    SELECT v.VendorName, i.InvoiceNumber, i.Balance
    FROM Vendors v
        RIGHT JOIN vwInvoices i ON v.vendorID = i.VendorID
    WHERE v.VendorID IS NULL

    --WHERE i.InvoiceNumber IS NOT NULL

    SELECT i.InvoiceID, ili.InvoiceLineItemDescription
    FROM InvoiceLineItems ili 
        LEFT JOIN Invoices i ON i.InvoiceID = ili.InvoiceID
    WHERE i.InvoiceID IS NULL

    SELECT cu.*, v.VendorID
    FROM ContactUpdates cu  
        LEFT JOIN Vendors v ON cu.VendorID = v.VendorID
    WHERE v.VendorID IS NULL
    
    */

USE Examples
/*
    select * from Departments
    select * from Employees
    select * from Projects


    Inner Join: just JOIN
    Outer Join: LEFT, RIGHT, FULL, 


    -- DeptName, DeptNo, LastName

    SELECT  d.DeptName,
            d.DeptNo, 
            e.LastName
    FROM Departments d
        FULL JOIN Employees e ON d.DeptNo = e.DeptNo
    ORDER BY d.DeptName, e.LastName
    




    Return a list of departments and their employees as well as
    the projeects they are on

    Return the 

    SELECT  DeptName,
            LastName,
            ProjectNo
    FROM Departments d 
        JOIN Employees e ON d.DeptNo = e.DeptNo
        LEFT JOIN Projects p ON e.EmployeeID = p.EmployeeID
    ORDER BY DeptName
*/

/*
    Now, I would like to know more about our operation. I want a
    list of all employees, departments, and projects. This report
    should show:
        1) Departments that don't have employees
        2) Employees that have not been assigned to a department
        3) Employees that have not been assigned to a project
        4) Projects that have not been assigned to employees
        5) Projects assigned to an employee not in the dB

    Return the 



    Select  d.DeptName, 
            e.LastName, 
            p.ProjectNo,
            [empEIT] = e.EmployeeID,
            [proEID] = p.EmployeeID
    FROM Departments    d  
        FULL JOIN Employees e ON d.DeptNo = e.DeptNo
        FULL JOIN Projects  p ON e.EmployeeID = p.EmployeeID
        

    -- WHERE (e.EmployeeID IS NOT NULL) and (p.ProjectNo IS NULL) 


-------------------------------------------------------------- CROSS JOIN
-- IMplicit Cross Join
    SELECT d.DeptNo, d.DeptName
    FROM Departments d, Employees e 
    ORDER BY d.DeptNo

-- Explicit Cross Join
    SELECT d.DeptNo, d.DeptName
    FROM Departments d CROSS JOIN Employees e 
    ORDER BY d.DeptNo
*/

USE AP

    SELECT  [Status] = 'Warning',
            i.InvoiceNumber,
            i.Balance
    FROM vwInvoices i 
    WHERE i.Balance BETWEEN 1 AND 99
UNION
    SELECT  [Status] = 'Send Collection Notice',
            i.InvoiceNumber,
            i.Balance
    FROM vwInvoices i 
    WHERE i.Balance > 500
UNION
    SELECT  [Status] = 'Cancel Account',
            i.InvoiceNumber,
            i.Balance
    FROM vwInvoices i 
    WHERE i.Balance BETWEEN 100 AND 500
UNION
    SELECT  [Status] = 'Paid',
            i.InvoiceNumber,
            i.Balance
    FROM vwInvoices i 
    WHERE i.Balance = 0
