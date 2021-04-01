--============================================================== Math
    SELECT  5*3, 5/3, 5%3,
            5*3.5, 5/3.5, 5%3.5

--============================================================== Date
    SELECT  GETDATE(), SYSDATETIMEOFFSET(), SYSDATETIME()

    SELECT  DATEDIFF(day, '7/04/2000', GETDATE()),
            EOMONTH(GETDATE()),
            EOMONTH('2/11/2020'),
            ISDATE('2/29/2020'),
            ISDATE('2/29/2021'),
            DATENAME(WEEKDAY, GETDATE())

--============================================================== Converting
    SELECT  GETDATE(),
            CONVERT(CHAR(10), GETDATE()),
            CONVERT(CHAR(15), GETDATE()),
            CONVERT(CHAR(11), GETDATE(), 1),
            CONVERT(CHAR(11), GETDATE(), 101),
            CAST( GETDATE() AS DATE),
            CAST( GETDATE() AS CHAR(10) ),
            CAST( SYSDATETIME() AS CHAR(10) ),
            CAST( SYSDATETIME() AS CHAR(15) )

--============================================================== Value Checking
----------------------------- VARCHAR
    DROP TABLE IF EXISTS Users;
        CREATE TABLE Users (
            id      INT     PRIMARY KEY     IDENTITY,
            un      VARCHAR(20),
            pw      VARCHAR(20)
        )
        INSERT INTO Users (un, pw) VALUES ('tom','myPassworD')

        DECLARE @un VARCHAR(20) = 'tom', @pw VARCHAR(20) = 'myPASSworD'

        -- This will work but will not work correctly, not case sensitive
        SELECT * FROM Users WHERE un = @un AND pw = @pw

        -- The fix to this
        SELECT * FROM Users WHERE un = @un AND CAST(pw AS varbinary) = CAST(@pw AS varbinary)
        SELECT * FROM Users WHERE un = @un AND CAST(pw AS varbinary) = CAST('myPassworD' AS varbinary)

----------------------------- NVARCHAR
    DROP TABLE IF EXISTS Users;
        CREATE TABLE Users (
            id      INT     PRIMARY KEY     IDENTITY,
            un      NVARCHAR(20),
            pw      NVARCHAR(20)
        )
        INSERT INTO Users (un, pw) VALUES ('tom','myPassworD')

        DECLARE @un NVARCHAR(20) = 'tom', @pw NVARCHAR(20) = 'myPASSworD'

        -- This will work but will not work correctly, not case sensitive
        SELECT * FROM Users WHERE un = @un AND pw = @pw

        -- The fix to this
        -- NVARCHAR does not work with as varBinary cast
        SELECT * FROM Users WHERE un = @un AND pw COLLATE LATIN1_GENERAL_CS_AS = @pw
        SELECT * FROM Users WHERE un = @un AND pw COLLATE LATIN1_GENERAL_CS_AS = 'myPassworD'
    DROP TABLE IF EXISTS Users

--============================================================== Comparing / Bit Switch          
            
    SELECT * FROM INvoices WHERE CreditTotal != 0       -- This "works" but is not universal
    SELECT * FROM INvoices WHERE CreditTotal <> 0

    SELECT *, [ToggleIsDeleted] = ~isDeleted 
    FROM Invoices 
    WHERE CreditTotal <> 0 OR isDeleted = 1

-- Return all Vendors from states that start with N but exclude any state that ends with K-Y

    SELECT * 
    FROM Vendors
    WHERE VendorState LIKE 'N[^K-Y]'

-- Return all Vendors where the vendor name starts with 'Am'

    SELECT *
    FROM Vendors
    WHERE VendorName LIKE 'Am%'         -- Much better way

    SELECT *
    FROM Vendors
    WHERE LEFT(VendorName, 2) = 'Am'    -- Will work but not as good or as fast

--============================================================== Sub-Queries

    -- Get a list of vendors that have invoices (34 rows)
    SELECT * 
    FROM Vendors
    WHERE VendorID IN (
        SELECT DISTINCT VendorID FROM Invoices
    )

    -- logical error
    SELECT * 
    FROM Vendors
    WHERE VendorID IN (
        SELECT DISTINCT InvoiceID FROM Invoices
    )

    -- Get a list of vendors who have no invoices (88 rows)
    SELECT * 
    FROM Vendors
    WHERE VendorID NOT IN (
        SELECT DISTINCT VendorID FROM Invoices
    )

--============================================================== Null

    SELECT COUNT(*) FROM Vendors
    SELECT COUNT(VendorID) FROM Vendors
    SELECT COUNT(VendorName) FROM Vendors
    SELECT COUNT(VendorAddress1) FROM Vendors
    SELECT COUNT(VendorAddress2) FROM Vendors
    SELECT COUNT(DefaultTermsID) FROM Vendors
    SELECT COUNT(DISTINCT DefaultTermsID) FROM Vendors

    SELECT  VendorName,
            [VendorAddress2] = ISNULL(VendorAddress2, ' '),
            [VendorPhone] = ISNULL(VendorPhone, '***-***-*****')
    From Vendors
    WHERE VendorAddress2 IS NULL

    --============================================================== Paging

    DECLARE @page INT = 0, @records INT = 10

    SELECT *
    FROM Vendors
    ORDER BY VendorName
        OFFSET (@page * @records) ROWS
        FETCH NEXT @records ROWS ONLY

    SELECT VendorName, (SELECT COUNT(*) FROM Vendors)/@records AS numOfPages
    FROM Vendors
    ORDER BY VendorName
        OFFSET (@page * @records) ROWS
        FETCH NEXT @records ROWS ONLY

