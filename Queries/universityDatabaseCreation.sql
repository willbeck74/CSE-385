USE master;
GO

DROP DATABASE IF EXISTS UniversityDatabase;
GO

CREATE DATABASE UniversityDatabase;
GO

USE UniversityDatabase;
GO

CREATE TABLE tblTeachers (
    teacherID           INT             NOT NULL    PRIMARY KEY     IDENTITY,
    name                VARCHAR(30)     NOT NULL,
    email               VARCHAR(90)     NULL,
    isRetired           BIT             NOT NULL    DEFAULT(0)
)
GO

CREATE TABLE tblCourses (
    courseID            INT             NOT NULL    PRIMARY KEY     IDENTITY,
    name                VARCHAR(60)     NOT NULL,
    section             CHAR(1)         NOT NULL,
    credits             INT             NOT NULL    DEFAULT(3)
)
GO

CREATE TABLE tblStudents (
    studentID           INT             NOT NULL    PRIMARY KEY     IDENTITY,
    name                VARCHAR(30)     NOT NULL,
    email               VARCHAR(90)     NULL,
    yearInSchool        INT             NOT NULL    DEFAULT(1)
)
GO

CREATE TABLE tblTeacherCourses (
    teacherID           INT             NOT NULL    FOREIGN KEY REFERENCES tblTeachers(teacherID),
    courseID            INT             NOT NULL    FOREIGN KEY REFERENCES tblCourses(courseID),
    isActive            BIT             NOT NULL    DEFAULT(1),    
    activeDate          DATE            NOT NULL,
    inActiveDate        DATE            NULL        DEFAULT(NULL),
    PRIMARY KEY (
        teacherID, courseID
    )
)
GO

CREATE TABLE tblStudentCourses (
    studentID           INT             NOT NULL    FOREIGN KEY REFERENCES tblStudents(studentID),
    courseID            INT             NOT NULL    FOREIGN KEY REFERENCES tblCourses(courseID),
    isDeleted           BIT             NOT NULL    DEFAULT(0),    
    currentGrade        FLOAT           NULL        DEFAULT(NULL),
    PRIMARY KEY (
        studentID, courseID
    )
)
GO