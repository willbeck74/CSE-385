/*
    -- Table Variables
    -- WHILE
    -- Cursors
*/
/*
    @@Fetch_status possible values:

    0 = The FETCH statement was successful.
   -1 = The FETCH statement 
*/

/*
---------------------------------------------------------------------------- Example 1
    DECLARE @Employees TABLE (
        empId       INT             PRIMARY KEY,
        empName     VARCHAR(30),
        salary      int,
        city        VARCHAR(30)
    )

    INSERT INTO @Employees(empId, empName, salary, city) VALUES 
        (1, 'Mohan',  12000, 'Oxford'),
        (2, 'Pavan',  25000, 'Cincinnati'),
        (3, 'Amit',   22000, 'Hamilton'),
        (4, 'Sonu',   22000, 'Rockland'),
        (5, 'Deepak', 28000, 'Middletown')

---------------------------------------------------------------------------- Actual Cursor Code
    DECLARE curr CURSOR STATIC FOR 
        SELECT empId, empName, salary FROM @Employees

    DECLARE @empId INT, @empName VARCHAR(30), @salary INT

    OPEN curr 

    IF(@@CURSOR_ROWS > 0) BEGIN 
        FETCH FROM curr INTO @empId, @empName, @salary
        WHILE(@@FETCH_STATUS = 0) BEGIN 
            PRINT CONCAT('ID: ', @empId, ' NAME: ', @empName, ' SALARY: ', @salary)
            FETCH FROM curr INTO @empId, @empName, @salary
        END 
    END 


    ----------- Clean your room!!!
    CLOSE curr 
    DEALLOCATE curr 
    DELETE @Employees
*/
---------------------------------------------------------------------------- Example 2
    SELECT  [parameter] = CONCAT(LOWER(TABLE_NAME), '_', COLUMN_NAME),
            [dataType]  = DATA_TYPE 
    FROM INFORMATION_SCHEMA.COLUMNS

    DECLARE @parameter varchar(50), @dataType char(7)

    OPEN curr 

    FETCH FROM curr INTO @parameter, @dataType
    WHILE(@@FETCH_STATUS = 0) BEGIN 
        SET @dataType = CASE 
                            WHEN @dataType IN ('int', 'smallint', 'bigint')        THEN 'int'
                            WHEN @dataType IN ('money', 'float')                   THEN 'double'
                            WHEN @dataType = 'bit'                                 THEN 'boolean'
                            WHEN @dataType LIKE '%date%'                           THEN 'Date'
                            ELSE                                                        'String'
                        END
        PRINT  CONCAT(@dataType, ' ', @parameter)
        FETCH FROM curr INTO @parameter, @dataType
    END

    -- CLEAN UP
    CLOSE curr 
    DEALLOCATE curr