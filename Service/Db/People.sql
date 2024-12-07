/* Initialize database environment for People object */
USE BlazorTest
go
DROP TABLE if exists dbo.People
GO
create table dbo.People
(
    PersonId      int not null
        primary key,
    Name          varchar(100),
    PromotionDate datetime
)
go
INSERT INTO dbo.People (PersonId,Name,PromotionDate)
VALUES 
(10944,'Antonio Langa','1991-12-01 00:00:00.000'),
(11203,'Julie Smith','1958-10-10 00:00:00.000'),
(11898,'Jose Hernandez','2011-05-03 00:00:00.000'),
(12130,'Kenji Sato','2004-01-09 00:00:00.000')
go
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
DROP PROCEDURE IF exists dbo.AddPerson
GO
CREATE PROCEDURE dbo.AddPerson
    @PeopleID int,
    @Name VARCHAR(100),
    @PromotionDate DATETIME
AS
Begin
    INSERT INTO dbo.People(PersonId, Name, PromotionDate) VALUES (@PeopleID,@Name,@PromotionDate)
end
GO
DECLARE @PromotionDate DATETIME = GETDATE();
EXEC dbo.AddPerson 99999,'Test',@PromotionDate;
GO
EXEC dbo.GetPeople
