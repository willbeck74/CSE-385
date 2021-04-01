--========================================================= Transactions and TRY...CATCH revisited
/*
 BEGIN TRAN
    UPDATE InvoiceLineItems SET InvoiceLineItemAmount = InvoiceLineItemAmount * 1.15
    DELETE FROM InvoiceLineItems

    SELECT * FROM InvoiceLineItems

    if(@@TRANCOUNT > 0) ROLLBACK TRAN
    if(@@TRANCOUNT > 0) COMMIT TRAN

--  ROLLBACK TRAN
--  COMMIT TRAN -- opposite of rollback

 SELECT * FROM InvoiceLineItems


 -------------------------------------------- Full Example of TRY...Catch, Transaction, Error logging

DECLARE @n1 INT = 10, @n2 INT = 2

    BEGIN TRAN
        BEGIN TRY
            DELETE FROM Errors
            SELECT [answer] = @n1 / @n2
        END TRY BEGIN CATCH
            IF(@@TRANCOUNT > 0) ROLLBACK TRAN

            DECLARE @params XML = ( SELECT [n1] = @n1, [n2] = @n2 FOR XML PATH('params'))

            EXEC spRecordError @params

        END CATCH
    if(@@TRANCOUNT > 0) COMMIT TRAN

    SELECT * FROM Errors
 

--========================================================= Hashbytes / Compression
    --Hashbytes: hashing data, 5-12 is the best algorithm 
    DECLARE @pw NVARCHAR(30) = 'p@S$W0Rd';

    SELECT  [HASHBYTES(SHA2_512)-V]        = HASHBYTES('SHA2_512', 'p@S$W0Rd'),
            [HASHBYTES(SHA2_512)-N]        = HASHBYTES('SHA2_512', CAST('p@S$W0Rd' AS NVARCHAR)),
            [COMPRESS]                     = COMPRESS('p@S$W0Rd'),
            [DECOMPRESS]                   = DECOMPRESS(COMPRESS('p@S$W0Rd')),
            [DECOMPRESS(WITH CAST)]        = CAST(DECOMPRESS(COMPRESS('p@S$W0Rd')) AS VARCHAR),
            [MD2]                          = HASHBYTES('MD2', @pw),
            [MD4]                          = HASHBYTES('MD4', @pw),
            [MD5]                          = HASHBYTES('MD5', @pw),
            [SHA]                          = HASHBYTES('SHA', @pw),
            [SHA1]                         = HASHBYTES('SHA1', @pw),
            [SHA2_256]                     = HASHBYTES('SHA2_256', @pw),
            [SHA2_512]                     = HASHBYTES('SHA2_512', @pw)
    FOR JSON PATH
*/

--========================================================= Querying XML datatype

    DROP TABLE IF EXISTS xmlTest
    GO

    CREATE TABLE xmlTest (
        studentId           INT         PRIMARY KEY         IDENTITY,
        testData            XML
    )
    GO

    INSERT INTO xmlTest (testData) VALUES
        (( SELECT [t1]=55, [t2]=87 FOR XML PATH('exams')                    )),
        (( SELECT [t1]=66, [t2]=87, [t3]=100 FOR XML PATH('exams')          )),
        (( SELECT [t1]=84, [t2]=43, [t3]=98 FOR XML PATH('exams')           )),
        (( SELECT [t1]=92, [t2]=87, [t3]=40, [t4]=97 FOR XML PATH('exams')  )),
        (( SELECT [t1]=81, [t2]=87, [t3]=89, [t4]=93 FOR XML PATH('exams')  ))
    GO

    SELECT * FROM xmlTest

    WITH tbl AS (
        SELECT  e.studentId,
                child.value('t1[1]', 'INT') as t1,
                child.value('t2[1]', 'INT') as t2,
                child.value('t3[1]', 'INT') as t3,
                child.value('t4[1]', 'INT') as t4
        FROM xmlTest e 
        CROSS APPLY e.testData.nodes('exams') parent(child)
    ) SELECT (
        SELECT
            [Test1] = ( SELECT AVG(t1) as avg, SUM(t1) as sum, COUNT(t1) as cnt for JSON PATH ),
            [Test2] = ( SELECT AVG(t2) as avg, SUM(t2) as sum, COUNT(t2) as cnt for JSON PATH ),
            [Test3] = ( SELECT AVG(t3) as avg, SUM(t3) as sum, COUNT(t3) as cnt for JSON PATH ),
            [Test4] = ( SELECT AVG(t4) as avg, SUM(t4) as sum, COUNT(t4) as cnt for JSON PATH )
        FROM tbl FOR JSON PATH
    ) FOR XML PATH('')


    SELECT * FROM Vendors FOR JSON PATH

