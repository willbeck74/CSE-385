-- C.R.U.D Operations

/*
-- CREATE (INSERT)

    INSERT INTO tblFriends (firstName, lastName, age, phoneNumber, [address])
    VALUES ('Tom', 'Ryan', 25, '123-456-7890', 'Oxford, OH')

    INSERT INTO tblFriends (firstName, lastName, age, phoneNumber, [address])
    VALUES ('Jack', 'Ryan', 25, '000-000-0000', 'NY, NY')

    SET IDENTITY_INSERT tblFriends ON -- if you turn on, have to turn off also

        INSERT INTO tblFriends (friendId, firstName, lastName, age, phoneNumber, [address])
        VALUES (500, 'Paul', 'Brick', 45, '000-000-0000', 'Oxford, OH')

    SET IDENTITY_INSERT tblFriends OFF

    SELECT * FROM tblFriends

    
-- READ (SELECT)
    -- New School Version of naming
    SELECT  firstName + ' ' + lastName AS fullName,
            age 
    FROM tblFriends

    -- Old School Version of naming
    SELECT  [fullName] = firstName + ' ' + lastName,
            age 
    FROM tblFriends
    WHERE [address] = 'NY, NY'

-- UPDATE

    UPDATE tblCars
    SET     make = 'HONDA', [year] = [year] + 1
    WHERE   make = 'HoNda'

    select * from tblCars where make = 'honda'

    UPDATE tblCars
    SET     make = 'Honda', [year] = [year] - 1
    WHERE   make = 'HoNda'

-- DELETE
    SELECT * FROM tblFriends

    DELETE
    FROM tblFriends
    WHERE friendId > 10

    SELECT * FROM tblFriends

*/

