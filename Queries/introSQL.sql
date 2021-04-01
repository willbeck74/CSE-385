USE master;
GO 

/*
    Older version of dropping a database...
    This is a safer way to do it too..
*/
IF DB_ID('Example') IS NOT NULL
    DROP DATABASE Example;

-- New version of dropping a database...
DROP DATABASE IF EXISTS Example;
GO

CREATE DATABASE Example;
GO

USE Example;
GO

-- Creating our first table

CREATE TABLE tblFriends (
    friendId        INT             NOT NULL    PRIMARY KEY     IDENTITY(1, 1),
    firstName       VARCHAR(20)     NOT NULL,
    lastName        VARCHAR(20)     NOT NULL,
    age             INT             NOT NULL    DEFAULT(-1),
    phoneNumber     VARCHAR(20)     NOT NULL    DEFAULT('(***) ***-****'),
    [address]       VARCHAR(100)    NULL        DEFAULT(NULL)
)
GO

/*
    C.R.U.D.

    Create  INSERT
    Read    SELECT
    Update  UPDATE
    Delete  DELETE
*/

--DELETE FROM tblFriends
TRUNCATE TABLE tblFriends
GO

INSERT INTO tblFriends (firstName, lastName, age, phoneNumber, address) VALUES ('A','A', 22, '(123)456-7890', 'A')
INSERT INTO tblFriends (firstName, lastName, age, phoneNumber)          VALUES ('B', 'B', 22, 'B')
INSERT INTO tblFriends (firstName, lastName, age)                       VALUES ('C', 'C', 22)
INSERT INTO tblFriends (firstName, lastName)                            VALUES ('D', 'D')
--INSERT INTO tblFriends (firstName)                                      VALUES ('E')

INSERT INTO tblFriends (firstName, lastName, age, phoneNumber, address) VALUES 
    ('A','A', 22, '(123)456-7890', 'A'),
    ('B', 'B', 22, 'B', 'B'),
    ('C', 'C', 22, 'C', 'C'),
    ('D', 'D', 22, 'D', 'D')

-- id	vin	make	model	year
-- 1	3N6CM0KN6FK202799	Subaru	Impreza	2009 

DROP TABLE IF EXISTS tblCars;
GO

CREATE TABLE tblCars (
    carId   INT             NOT NULL    PRIMARY KEY     IDENTITY,
    vin     VARCHAR(20)     NOT NULL,
    make    VARCHAR(20)     NOT NULL,
    model   VARCHAR(40)     NOT NULL,
    [year]  INT             NOT NULL
)
GO

-- c:\temp\CarData.txt
BULK INSERT tblCars 
    FROM 'C:\Users\willbeck\Desktop\Lab-01-People.txt'
    WITH (
        FIRSTROW = 2,
        ROWTERMINATOR = '\n',
        FIELDTERMINATOR = '\t',
        KEEPIDENTITY
    )
GO

SELECT * FROM tblCars WHERE make = 'Honda'
--SELECT make, model, year FROM tblCars WHERE make = 'Honda'