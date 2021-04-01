/*
    -- XML
    -- SELECT INTO
    -- MERGE
    -- Dynamic TSQL
*/
--=================================================== XML
/*
    DECLARE @xml XML = 
            '
                <records>
                    <users>
                        <data id="1" email="tryan@gmail.com">
                            <fName>Tom</fName>
                            <lName>Ryan</lName>
                            <phone>123-456-7890</phone>
                        </data>
                        <data id="2" email="bross@gmail.com">
                            <fName>Bob</fName>
                            <lName>Ross</lName>
                            <phone>555-111-2222</phone>
                        </data>
                        <data id="3" email="tanderson@gmail.com">
                            <fName>Tammy</fName>
                            <lName>Anderson</lName>
                            <phone>678-901-2345</phone>
                        </data>
                    </users>
                </records>
            '
            SELECT 
                     [vendorID]     =  rec.value('@id','int') 
                    ,v.VendorName
                    ,[firstName]    =  CAST(rec.query('fName/text()') AS VARCHAR)
                    ,[lastName]     =  CAST(rec.query('lName/text()') AS VARCHAR)
                    ,[email]        =  rec.value('@email', 'varchar(100)')
                    ,[phone]        =  CAST(rec.query('phone/text()') AS VARCHAR)
            FROM @xml.nodes('records/users/data') Records(rec)
                JOIN Vendors v ON v.VendorID = rec.value('@id','int')
            ORDER BY lastName
*/

--=================================================== SELECT INTO / MERGE
/*
    -- SELECT INTO
    SELECT * INTO InvoiceBackup FROM Invoices



    -- SELECT 
    --     InvoiceNumber, VendorID
    -- INTO
    --     InvoiceBackup
    -- FROM 
    --     Invoices
    -- WHERE 
    --     VendorID between 20 and 30 
    DROP TABLE InvoiceBackup

    -- MERGE and SELECT INTO 
    BEGIN TRAN
        -- Make a copy of the Terms Table
        SELECT * INTO TermsUpdates FROM Terms

        -- Add a record to TermsUpdates
        INSERT INTO TermsUpdates(TermsDescription, TermsDueDays)
            VALUES('Net due 120 days', 120)

        -- Mess up the Terms table (to simulate what the data originally looked like)
        UPDATE Terms SET TermsDescription = NEWID(), TermsDueDays = 0
        UPDATE Terms SET TermsDueDays = 500 WHERE TermsID = 5
        INSERT INTO Terms(TermsDescription, TermsDueDays) VALUES
             ('Sample row 1', 1000)
            ,('Sample row 2', 2000)
            ,('Sample row 3', 3000)

        SELECT 'Orig Terms Data', * FROM Terms

        SET IDENTITY_INSERT Terms ON 

            MERGE       Terms           t            -- Target
            USING       TermsUpdates    tu           -- Source
            ON t.TermsID = tu.TermsID
            WHEN MATCHED AND t.TermsDueDays < 500 THEN 
                UPDATE SET
                    t.TermsDescription  = tu.TermsDescription,
                    t.TermsDueDays      = tu.TermsDueDays
            WHEN NOT MATCHED BY SOURCE THEN
                DELETE 
            WHEN NOT MATCHED BY TARGET THEN 
                INSERT(TermsID, TermsDescription, TermsDueDays)
                VALUES(tu.TermsID, tu.TermsDescription, tu.TermsDueDays)
            ;
        SET IDENTITY_INSERT Terms OFF

    ROLLBACK TRAN
*/
--=================================================== Dynamic SQL

    DECLARE @VendorID VARCHAR(10) = 5
    DECLARE @cmd NVARCHAR(100) = 'SELECT * FROM Vendors WHERE VendorID = @VendorID'
    DECLARE @type NVARCHAR(20) = '@VendorID INT'

    -- ' OR 1=1' gets through security 

    SELECT * FROM Vendors WHERE VendorID = @VendorID
    EXEC('SELECT * FROM Vendors WHERE VendorID = 5')
    EXEC('SELECT * FROM Vendors WHERE VendorID ' + @VendorID)

    EXEC sp_executesql @cmd, @type, @VendorID



