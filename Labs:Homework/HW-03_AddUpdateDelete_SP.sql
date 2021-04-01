-- Create a single Stored Procedure that will allow for Adding, Updating, and Deleting to/from the Terms table.

SELECT * FROM Terms

GO
    CREATE PROCEDURE spAddUpdateDeleteTerms2
        @TermsID            INT,
        @TermsDescription   VARCHAR(40),
        @TermsDueDays       INT,
        @Delete             BIT = 0
    AS BEGIN
        IF @Delete = 1 BEGIN 
            BEGIN TRY
                DELETE FROM Terms WHERE TermsID = @TermsID
            END TRY BEGIN CATCH
                PRINT 'CANNOT DELETE PARENT RECORD'
            END CATCH
        END ELSE IF (@TermsID = 0)
            BEGIN
                INSERT INTO Terms (TermsDescription, TermsDueDays)
                            Values(@TermsDescription, @TermsDueDays)
        END ELSE BEGIN
            UPDATE Terms
            SET TermsDescription = @TermsDescription, TermsDueDays = @TermsDueDays 
            WHERE TermsID = @TermsID
        END
    END
GO

    EXEC spAddUpdateDeleteTerms2 0, 'Net due 15 days', 15

    SELECT * FROM Terms