USE College;
/*CREATE DATABASE College3;
  DROP DATABASE [College2]

GO
*/


CREATE TABLE dsuser02.Departments (
	DepartmentId	INT Primary Key NOT NULL,
	DepartmentName  VARCHAR(20)
);

CREATE TABLE COLLEGE.dsuser02.Departments2 (
	DepartmentId	INT Primary Key NOT NULL,
	DepartmentName  VARCHAR
);


CREATE TABLE COLLEGE.dsuser02.Course (
	CourseId		INT Primary Key NOT NULL,
	CourseName		VARCHAR(100),
	DepartmentID	INT,
	TeacherId		INT
)

--- Drop a table 
DROP TABLE dsuser02.Departments

--- Change the structure of a table

ALTER TABLE dsuser02.Course ADD Test  DECIMAL(8,3) 
ALTER TABLE dsuser02.Course ADD Test1 DECIMAL(8,3) NOT NULL
ALTER TABLE dsuser02.Course ADD Test2 DECIMAL(8,3) NOT NULL

ALTER TABLE dsuser02.Course DROP COLUMN Test


--- Add some data to an existing table
CREATE TABLE College.dsuser02.Departments(
	DepartmentId	INT NOT NULL Primary Key,
	DepartmentName  VARCHAR(20)
);

INSERT INTO College.dsuser02.Departments (DepartmentId,DepartmentName) 
VALUES (1,'English');

INSERT INTO College.dsuser02.Departments (DepartmentId,DepartmentName) 
VALUES (2,'Science'), (3,'Arts')

/* SELECT * FROM College.dsuser02.Departments */

INSERT INTO dsuser02.Departments VALUES (3,'Arts')

INSERT INTO Departments VALUES (4,'Sport')
/* SELECT * FROM College.dsuser02.Departments */

INSERT INTO dsuser02.Departments VALUES (5,'')
INSERT INTO dsuser02.Departments VALUES (6,'Data Scientist')
/* SELECT * FROM College.dsuser02.Departments */

--- View the content of a table

SELECT * FROM College.dsuser02.Departments

SELECT DepartmentName, 
       DepartmentId  DepartmentName  
FROM Departments

SELECT DepartmentName, DepartmentId 
FROM College.dsuser02.Departments
WHERE DepartmentId BETWEEN 1 AND 2  -- IN (2,4)
ORDER BY DepartmentId DESC

SELECT DepartmentName, DepartmentId 
FROM Departments
WHERE DepartmentId  IN (2,4,6)
ORDER BY DepartmentId DESC

--- Create a new table based on an existing table

SELECT DepartmentName, DepartmentId 
INTO   College.dsuser02.DepTest
FROM   College.dsuser02.Departments
WHERE DepartmentId  IN (2,4,6)
--ORDER BY DepartmentId DESC

SELECT * FROM dsuser02.Course

INSERT INTO College.dsuser02.Course  
           (CourseId,CourseName,[DepartmentID],[TeacherId],[Test1], [Test2]) 
VALUES (1,'English', 20, 222, 95, 79.32),
       (2,'English', 20, 222, 90, 99.5 ),
       (3,'Math',    50, 111, 50, 39.5 )

INSERT INTO College.dsuser02.Course 
VALUES (4,'Liture',  3, 225, 100, 87.5 ),
       (5,'Economics', 880, 235, 90, 82.25 )

SELECT * FROM dsuser02.Course
ORDER by Test1 desc

SELECT  CourseId,CourseName
INTO   College.dsuser02.DepTest2
FROM   College.dsuser02.Course
WHERE  DepartmentId  IN (2,4,5)

SELECT * FROM College.dsuser02.DepTest2
SELECT * FROM College.dsuser02.DepTest

--- Add data to an existing table, based on data from another table

INSERT INTO College.dsuser02.DepTest
SELECT DepartmentName, DepartmentId
FROM   College.dsuser02.Departments
WHERE DepartmentId  IN (1,3)
--ORDER BY DepartmentId DESC

SELECT * FROM College.dsuser02.DepTest

--- Update a column in a table

ALTER TABLE College.dsuser02.DepTest ADD Test DECIMAL(8,3)

SELECT * FROM DepTest

UPDATE DepTest SET test = 0
SELECT * FROM DepTest

UPDATE DepTest SET test = 5
WHERE DepartmentId < 3

UPDATE DepTest SET test = 10
WHERE DepartmentId >= 3

SELECT * FROM DepTest

--- Delete data from a table (without deleting its structure)

DELETE FROM DepTest
WHERE DepartmentId >= 3

SELECT * FROM DepTest

--- Delete will remove the data row by row, while looking the table until it finish
DELETE FROM DepTest
WHERE DepartmentName LIKE 'sci%'

SELECT * FROM DepTest

--- Truncate will remove the data all at once
TRUNCATE TABLE DepTest
SELECT * FROM DepTest


SELECT * FROM DEpartments
WHERE DepartmentName LIKE 'S%'  


SELECT *
INTO dsuser02.Teachers
FROM dbo.Teachers

SELECT * FROM dsuser02.Teachers

/***********************************************************************************/
CREATE TABLE dsuser02.Manufacturers (
	Code	INT Primary Key NOT NULL,
	[Name]  VARCHAR(20)
);
INSERT INTO Manufacturers(Code,[Name]) 
VALUES (1,'Sony'),
       (2,'Creative Labs'),
       (3,'Hewlett-Packard'),
	   (4,'Iomega'),
	   (5,'Fujitsu'),
	   (6,'Winchester');
SELECT * FROM  dsuser02.Manufacturers

CREATE TABLE dsuser02.Products (
	Code	INT Primary Key NOT NULL,
	[Name]  VARCHAR(20),
	Price   DECIMAL(8,2) NOT NULL,
	Manufacturer INT NOT NULL
);
INSERT INTO Products(Code,[Name],Price,Manufacturer) 
VALUES(1,'Hard drive',240,5),
	   (2,'Memory',120,6),
	   (3,'ZIP drive',150,4),
	   (4,'Floppy disk',5,6),
	   (5,'Monitor',240,1),
       (6,'DVD drive',180,2),
       (7,'CD drive',90,2),
       (8,'Printer',270,3),
       (9,'Toner cartridge',66,3),
       (10,'DVD burner',180,2);

SELECT * from [dsuser02].[Products]

SELECT [Name] 
from [dsuser02].[Products]
where Price<=200


SELECT *
from dsuser02.Products
where 60<=Price  and Price <=120

SELECT * from [dsuser02].[Products]

SELECT *, Price*100 as double_price
from dsuser02.Products

SELECT AVG(Price)   as avg_price   
from dsuser02.Products

SELECT count(*)
from dsuser02.Products
where Price>=100     

SELECT * FROM Products



