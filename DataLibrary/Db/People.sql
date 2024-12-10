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
INSERT INTO dbo.People (PersonId, Name, PromotionDate)
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
-- test for type creation
SELECT name, system_type_id, user_type_id
FROM sys.types
WHERE is_table_type = 1
GO
SELECT *
FROM dbo.People
go

--create Get People procedure

DROP PROCEDURE IF exists dbo.GetPeople
GO
CREATE PROCEDURE dbo.GetPeople
AS
Begin
    SELECT * FROM dbo.People
end
GO

-- test GetPeople procedure

EXEC dbo.GetPeople
go

--create AddPerson procedure

CREATE OR ALTER PROCEDURE dbo.AddPerson @Person UT_People READONLY,
                                        @message VARCHAR(100) OUTPUT
AS
Begin
    SET @message = 'Add successful'
    BEGIN TRAN
        BEGIN TRY
            INSERT INTO dbo.People(PersonId, Name, PromotionDate)
            SELECT PersonId, Name, PromotionDate
            FROM @Person;
            COMMIT TRAN
        END TRY
        BEGIN CATCH
            SET @message = 'Add failed'
            ROLLBACK TRAN
        end catch
end
go

-- test AddPerson procedure

DECLARE @Person UT_People
DECLARE @message VARCHAR(100)
INSERT INTO @Person (PersonId, Name, PromotionDate)
SELECT 99999, 'Test', GETDATE()
EXEC dbo.AddPerson @Person, @message OUTPUT
SELECT @message
GO
EXEC dbo.GetPeople
GO

-- create UpdatePerson procedure

CREATE OR ALTER PROCEDURE dbo.UpdatePerson @Person UT_People READONLY,
                                           @message VARCHAR(100) OUTPUT
AS
Begin
    SET @message = 'Update successful'
    BEGIN TRAN
        BEGIN TRY
            DECLARE @PersonID INT, @Name VARCHAR(100), @PromotionDate Datetime
            SELECT @PersonID = PersonId, @Name = Name, @PromotionDate = PromotionDate FROM @Person
            UPDATE dbo.People
            SET Name          = @Name,
                PromotionDate = @PromotionDate
            WHERE PersonId = @PersonId
            COMMIT TRAN
        END TRY
        BEGIN CATCH
            SET @message = 'Update failed';
            ROLLBACK TRAN
        end catch
end
GO

-- test UpdatePerson procedure

DECLARE @Person UT_People
DECLARE @message VARCHAR(100)
INSERT INTO @Person (PersonId, Name, PromotionDate)
SELECT 99999, 'Test2', GETDATE()
EXEC dbo.UpdatePerson @Person, @message OUTPUT
SELECT @message
GO
EXEC dbo.GetPeople
GO

-- create DeletePerson procedure

DROP PROCEDURE IF EXISTS dbo.DeletePerson
GO
CREATE OR ALTER PROCEDURE dbo.DeletePerson @PersonId INT,
                                           @message VARCHAR(100) OUTPUT
AS
begin
    SET @message = 'Delete successful'
    DELETE dbo.People WHERE PersonID = @PersonId
    IF @@ERROR <> 0 SET @message = 'Delete failed'
end
GO

-- test DeletePerson procedure
DECLARE @message VARCHAR(100)
EXEC dbo.DeletePerson 99999, @message OUTPUT
SELECT @message
GO
EXEC dbo.GetPeople