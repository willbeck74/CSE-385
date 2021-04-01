USE Example;
DROP TABLE IF EXISTS [tblPeople]


-- id	first_name	last_name	email	gender	ip_address
-- 1	Cherilyn	Camden	ccamden0@huffingtonpost.com	Male	184.129.31.27

CREATE TABLE tblPeople (
    peopleId        INT             NOT NULL        PRIMARY KEY     IDENTITY(1, 1),
    firstName       VARCHAR(20)     NOT NULL,
    lastName        VARCHAR(20)     NOT NULL,
    email           VARCHAR(40)     NULL            DEFAULT(NULL),
    gender          VARCHAR(20)     NOT NULL,
    ipAddress       VARCHAR(20)     NULL            DEFAULT(NULL)
)
GO

BULK INSERT tblPeople
    FROM 'c:\temp\Lab-01-People.txt'
    WITH (
        FIRSTROW = 2,
        ROWTERMINATOR = '\n',
        FIELDTERMINATOR = '\t',
        KEEPIDENTITY
    );
GO

SELECT * FROM tblPeople WHERE firstName = 'Dale'

SELECT firstName, lastName, email FROM tblPeople WHERE gender = 'Female'