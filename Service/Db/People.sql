/* Initialize database environment for People object */
USE BlazorTest
go
DROP TABLE if exists dbo.People
GO
create table dbo.People
(
    PersonId      int          not null primary key,
    Name          varchar(100) not null,
    PromotionDate datetime     not null
)
go
INSERT INTO dbo.People (PersonId,Name,PromotionDate)
VALUES (10944, 'Antonio Langa', '1991-12-01 00:00:00.000'),
       (11203, 'Julie Smith', '1958-10-10 00:00:00.000'),
       (11898, 'Jose Hernandez', '2011-05-03 00:00:00.000'),
       (12130, 'Kenji Sato', '2004-01-09 00:00:00.000')
go
-- create user defined type for people
DROP PROCEDURE IF exists dbo.AddPerson
GO
DROP PROCEDURE IF EXISTS dbo.UpdatePerson
GO
DROP TYPE IF EXISTS dbo.UT_People
GO
CREATE TYPE dbo.UT_People AS TABLE
(
    PersonId      int          not null,
    Name          varchar(100) not null,
    PromotionDate datetime default GETDATE()
)
GO
SELECT name, system_type_id, user_type_id
FROM sys.types
WHERE is_table_type = 1
GO
SELECT * FROM dbo.People
go
DROP PROCEDURE IF exists dbo.GetPeople
GO
CREATE PROCEDURE dbo.GetPeople
AS
Begin
    SELECT * FROM dbo.People
end
GO
EXEC dbo.GetPeople
go
CREATE PROCEDURE dbo.AddPerson @People UT_People READONLY
AS
Begin
    INSERT INTO dbo.People(PersonId, Name, PromotionDate)
    SELECT PersonId, Name, PromotionDate
    FROM @People;
end
go
DECLARE @People UT_People
INSERT INTO @People (PersonId, Name, PromotionDate)
SELECT 99999, 'Test', GETDATE()
EXEC dbo.AddPerson @People
GO
EXEC dbo.GetPeople
GO
CREATE PROCEDURE dbo.UpdatePerson @Person UT_People READONLY
AS
Begin
    DECLARE @PersonID INT, @Name VARCHAR(100), @PromotionDate Datetime
    SELECT @PersonID = PersonId, @Name = Name, @PromotionDate = PromotionDate FROM @Person
    UPDATE dbo.People
    SET Name          = @Name,
        PromotionDate = @PromotionDate
    WHERE PersonId = @PersonId
end
GO
DECLARE @Person UT_People
INSERT INTO @Person (PersonId, Name, PromotionDate)
SELECT 99999, 'Test2', GETDATE()
EXEC dbo.UpdatePerson @Person
GO 
EXEC dbo.GetPeople
