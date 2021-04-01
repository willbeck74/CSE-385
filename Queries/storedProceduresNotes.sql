/*---------------------------------------------------------------------------------------
    -- VendorID, InvoiceNumber, Balance, Status
    --      Status  = 0         -> 'paid'
                    = 1-199     -> 'Send Reminder'
                    = 200-499   -> 'ALERT'
                    >= 500      -> 'Cancel Account'

    SELECT  VendorID
            ,InvoiceNumber
            ,Balance
            ,[Status] = 'Paid'
    FROM vwInvoices
    WHERE Balance = 0
UNION
    SELECT  VendorID
        ,InvoiceNumber
        ,Balance
        ,[Status] = 'Send Reminder'
    FROM vwInvoices
    WHERE Balance BETWEEN 1 AND 199.99
UNION
    SELECT  VendorID
            ,InvoiceNumber
            ,Balance
            ,[Status] = 'ALERT'
    FROM vwInvoices
    WHERE Balance BETWEEN 200 AND 499.99
UNION
    SELECT  VendorID
        ,InvoiceNumber
        ,Balance
        ,[Status] = 'Cancel Account'
    FROM vwInvoices
    WHERE Balance >= 500

    -- Case/Switch Statement

    SELECT  VendorID
            ,InvoiceNumber
            ,Balance
            ,[Status] = CASE    
                            WHEN Balance = 0    THEN 'Paid'
                            WHEN Balance < 200  THEN 'Send Reminder'
                            WHEN Balance < 500  THEN 'ALERT'
                            ELSE                     'Cancel Account'
                        END 
    FROM vwInvoices
*/

/*---------------------------------------------------------------------------------------
    VendorID, VendorName, Check (if vendorname contains a ', then YES else no)


    -- UNION
        SELECT  VendorID
                ,VendorName
                ,[Check] = 'YES'
        FROM Vendors
        WHERE VendorName LIKE '%''%'
    UNION 
        SELECT  VendorID
                ,VendorName
                ,[Check] = 'no'
        FROM Vendors
        WHERE VendorName NOT LIKE '%''%'

    -- CASE
        SELECT  VendorID
                ,VendorName
                ,[Check] =  CASE 
                                WHEN VendorName LIKE '%''%'     THEN 'YES'
                                ELSE                            'no'
                            END 
        FROM Vendors

    -- IIF
        SELECT  VendorID
                ,VendorName
                ,[Check] =  IIF(VendorName LIKE '%''%', 'YES', 'no')
        FROM Vendors
*/

/*---------------------------------------------------------------------------------------
    -- VendorID, Address - but: if address1 is NULL then use Addres2.
                                if address2 is NULL then use Phone.
                                if phone is NULL then simply return 'error'



    -- CASE
    SELECT  VendorID
            ,[Contact] =    CASE 
                                WHEN VendorAddress1 IS NOT NULL THEN VendorAddress1
                                WHEN VendorAddress2 IS NOT NULL THEN VendorAddress2
                                WHEN VendorPhone IS NOT NULL    THEN VendorPhone
                                ELSE                                 'ERROR' 
                            END 
    FROM Vendors

    -- IIF
    SELECT  VendorID
            ,[Contact] = IIF(VendorAddress1 IS NOT NULL, VendorAddress1,
                         IIF(VendorAddress2 IS NOT NULL, VendorAddress2,
                         IIF(VendorPhone    IS NOT NULL   , VendorPhone, 'ERROR')))
    FROM Vendors
*/

/*
-- USE IIF() to flip-flop TermsIS of InvoiceNumber '125520-1' from a 1 to a 2 and back

    UPDATE Invoices
    SET TermsID = IIF(TermsID = 1, 2, 1)
    WHERE InvoiceNumber = '125520-1'

    select * from Invoices where InvoiceNumber = '125520-1'

-- USE CASE to flip-flop TermsIS of InvoiceNumber '125520-1' from a 1 to a 2 and back

    UPDATE Invoices
    SET TermsID =   CASE 
                        WHEN TermsID = 1 THEN 2
                        ELSE                  1
                    END
    WHERE InvoiceNumber = '125520-1'

    select * from Invoices where InvoiceNumber = '125520-1'

-- Using an IF statement with an EXISTS

    IF EXISTS (SELECT NULL FROM Invoices WHERE InvoiceNumber = '125520-1' AND TermsID = 1) BEGIN
        UPDATE Invoices SET TermsID = 2 WHERE InvoiceNumber = '125520-1'
    END ELSE BEGIN
        UPDATE Invoices SET TermsID = 1 WHERE InvoiceNumber = '125520-1'
    END

    select * from Invoices where InvoiceNumber = '125520-1'
*/

/* -- Stored Procedure
    GO
        CREATE PROCEDURE spAddGLAccount
            @AccountNo          INT,
            @AccountDescription VARCHAR(50)
        AS BEGIN
            IF NOT EXISTS (SELECT NULL FROM GLAccounts WHERE AccountNo = @AccountNo) BEGIN
                INSERT INTO GLAccounts (AccountNo, AccountDescription) VALUES 
                    (@AccountNo, @AccountDescription)
            END
        END
    GO


    EXEC spAddGLAccount 99, 'Sample'

    SELECT * FROM GLAccounts
    
    */

    /*
    GO
         CREATE PROCEDURE spAddUpdateGLAccount
            @AccountNo          INT,
            @AccountDescription VARCHAR(50)
        AS BEGIN
            IF NOT EXISTS (SELECT NULL FROM GLAccounts WHERE AccountNo = @AccountNo) BEGIN
                INSERT INTO GLAccounts (AccountNo, AccountDescription) VALUES 
                    (@AccountNo, @AccountDescription)
            END ELSE BEGIN
                UPDATE GLAccounts 
                SET AccountDescription = @AccountDescription
                WHERE AccountNo = @AccountNo
            END
        END
    GO
    

    EXEC spAddUpdateGLAccount 98, 'Sample2'

    SELECT * FROM GLAccounts
    
    */

/*
     GO
         ALTER PROCEDURE spAddUpdateDeleteGLAccount
            @AccountNo          INT,
            @AccountDescription VARCHAR(50),
            @Delete             BIT = 0
        AS BEGIN
            IF @Delete = 1 BEGIN
                BEGIN TRY
                    DELETE FROM GLAccounts WHERE AccountNo = @AccountNo
                END TRY BEGIN CATCH
                    PRINT 'CANNOT DELETE PARENT RECORD'
                END CATCH
            END ELSE IF NOT EXISTS (SELECT NULL FROM GLAccounts WHERE AccountNo = @AccountNo) BEGIN
                INSERT INTO GLAccounts (AccountNo, AccountDescription) VALUES 
                    (@AccountNo, @AccountDescription)
            END ELSE BEGIN
                UPDATE GLAccounts 
                SET AccountDescription = @AccountDescription
                WHERE AccountNo = @AccountNo
            END
        END
    GO
    */

    EXEC spAddUpdateDeleteGLAccount 552, 'HelloWorld', 1

    SELECT * FROM GLAccounts