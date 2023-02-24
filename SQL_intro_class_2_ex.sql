USE COLLEGE		

/* ------------------------------------------------
                    DATA MANIPULATION   
-------------------------------------------------  */


	--- existing data on new table
SELECT *
--INTO dsuser29.Student
FROM dbo.Students

	--- existing data on existing table

INSERT INTO dsuser29.Student
SELECT * 
FROM dbo.Students
WHERE StudentId > 275

SELECT * FROM dsuser29.Student


---- UPDATE
ALTER TABLE dsuser29.Student ADD age INT

UPDATE dsuser29.Student 
	SET age = -1, 
        FirstName = ''
WHERE Gender = 'M'

---- DELETE

    ---- delete one row at a time
DELETE dsuser29.Student 
WHERE Gender = 'M'


--------------------------------------------------------------------------

SELECT 
	   StudentId,
	   CASE WHEN (StudentId  < 100) THEN ('A')
	        WHEN (StudentId  >= 100 AND StudentId < 200) THEN ('B')
			--WHEN (StudentId BETWEEN 100 AND 199) THEN ('B')
			ELSE ('C')
		END AS StudentIdGroup,
		FirstName,
		LastName,
		Gender
FROM dbo.Students;

SELECT StudentId,
	   CASE WHEN (StudentId  < 100) THEN ('A')
	        WHEN (StudentId  >= 100 AND StudentId < 200) THEN ('B')
			--WHEN (StudentId BETWEEN 100 AND 199) THEN ('B')
			ELSE ('C')
		END StudentIdGroup,
		FirstName,
		LastName,
		Gender
INTO dsuser29.Students2
FROM dbo.Students

DROP TABLE dsuser29.Students2

SELECT * FROM dsuser29.Students2

UPDATE dsuser29.Students2 SET StudentIdGroup = ''

UPDATE dsuser29.Students2 
       SET StudentIdGroup = (
	   CASE WHEN (StudentId  < 100) THEN ('A')
	        WHEN (StudentId >= 100 AND StudentIdGroup < 200) THEN ('B')
			--WHEN (StudentId BETWEEN 100 AND 199) THEN ('B')
			ELSE ('C')
		END
	   )
WHERE Gender = 'M'

-------------------------------------------

---- Functions

SELECT log(100), log(100,2), log(100,10), log10(100)

SELECT log(100), exp(log(100)), exp(100)

SELECT round(1.23655786432,0)

SELECT CEILING(1.23), CEILING(1.76)
SELECT FLOOR(1.23), FLOOR(1.76)

SELECT ROUND(RAND()*100,0)

SELECT * ,
	log(Grades,2) AS Grades_log2,
	log(Grades) AS Grades_log,
	log10(Grades) AS Grades_log10,
	exp(Grades) AS Grades_exp,
	exp(log(Grades)) AS Grades_log_exp,
	round(Grades,2) AS Grades_dec2,
	round(Grades,0) AS Grades_int,
	ceiling(Grades) AS Grades_ceiling,
	floor(Grades) AS Grades_floor,
	rand() AS rand
FROM dbo.Classrooms


SELECT *, 
      FirstName + LastName,
      FirstName + ' ' + LastName AS StudentName,
      LastName  + ',' + FirstName AS NameStudent
FROM dbo.Students

SELECT CHAR(39), ASCII('a'), CHAR(97)

SELECT FirstName, LEFT(LTRIM(FirstName),2), RIGHT(FirstName,3), SUBSTRING(FirstName, 3, 4),
	SUBSTRING(FirstName, LEN(FirstName) - 2, 3)
FROM dbo.Students

SELECT FirstName, REPLACE(FirstName,'sa','NN')
FROM dbo.Students

SELECT FirstName, REPLACE(FirstName,' ','')
FROM dbo.Students

SELECT LTRIM(' ABC'), LTRIM('   ABC'), TRIM('ABC   ')

'2022-01-20'


SELECT '22/08/2006' AS [date],
	   LEFT('22/08/2006',2) AS DAY,
	   SUBSTRING('22/08/2006',4,2) AS MONTH,
	   RIGHT('22/08/2006',4) AS YEAR,
	   LEN('22/08/2006') AS len_date,
	   REPLACE('22/08/2006','/','-') AS date2,
	   REVERSE('22/08/2006')

	   --- ss's 


SELECT   'ss' + CHAR(39) + 's' AS mystring,
         ASCII('&'),
         CHAR(38)

SELECT SYSDATETIME() AS d1, 
       GETDATE() AS d2,
	   YEAR(GETDATE()) AS YEAR,
	   MONTH(GETDATE()) AS MONTH,
	   DAY(GETDATE()) AS DAY,
	   ISDATE(GETDATE()) AS d3,
	   ISDATE('22/08/2006') AS d4

CREATE TABLE dates (
	Day1 DATETIME,
	Day2 CHAR(12)
)

INSERT INTO dates VALUES ( GETDATE() , GETDATE() )
INSERT INTO dates VALUES ('08/22/2006','22/08/2006')
INSERT INTO dates VALUES ('2006-08-22','22/08/2006')


SELECT * FROM dates

-- 2022-07-10 18:00:44.253	Jul 10 2022 
-- 2006-08-22 00:00:00.000	22/08/2006  
-- 2006-08-22 00:00:00.000	22/08/2006  

SELECT GETDATE(),
       DATEDIFF(YEAR, '08/22/2006', GETDATE()) AS datedff,
	   DATEDIFF(MONTH, '2020-01-01', GETDATE()) AS datedff2, -- YYYY-MM-DD '2020-01-01'
	   DATEADD(DAY, -60, GETDATE() ) AS datedd


-- 2022-07-10 18:06:20.023	16	30	2022-05-11 18:06:20.023


SELECT *, DATEDIFF(MINUTE, Day1, GETDATE())
FROM dates


select * from Courses


---------------------------------------------------------------------------------------------
------ Solution to the exercice
---------------------------------------------------------------------------------------------

/*
Table 1.   Create (using select, no need to save to real table) a new column in table Classroom that shows the grades in the following categories:
(A) : > 90, (B) 80-89, (C) 70-79, (D)  < 70

*/

SELECT *,
	CASE WHEN (Grades >= 90) THEN ('A')
	     WHEN (FLOOR(Grades) BETWEEN 80 AND 89) THEN ('B')
		 WHEN (FLOOR(Grades) BETWEEN 70 AND 79) THEN ('C')
		 ELSE ('D')
	END AS GradeGroup
FROM dbo.Classrooms


/*
Table 2.  Using the table courses, select only the courses of department 2 and create a new table. After that, create a second table for courses of department 3.
Add the table that you created for department 3 to the table created for department 2.
*/

SELECT *
INTO dsuser29.Courses2
FROM dbo.Courses
WHERE DepartmentID = 2

SELECT *
INTO dsuser29.Courses3
FROM dbo.Courses
WHERE DepartmentID = 3

INSERT INTO dsuser29.Courses2
SELECT * FROM dsuser29.Courses3

/*
Table3.   Form table Teachers, select the TeacherID, gender, and join the first name and last name to a new column. Save the result to a new table.  Make the same with the Student table.
Now add the results of the students to the teacher’s result. 
What problem do you find when adding them to the same table?
What solution do you propose to solve it?
*/

-- DROP TABLE dsuser29.teachers
SELECT TeacherId + 1000 AS [Id],				---- problem 1: when joining the tables we will get repeated Id's. Solution: add 1000 to teachers ID's
       gender, 
	   FirstName + ' ' + LastName AS [name]
INTO dsuser29.teachers
FROM dbo.Teachers

-- DROP TABLE dsuser29.students
SELECT StudentId + 2000 AS [Id] ,             ---- problem 1: when joining the tables we will get repeated Id's. Solution: add 1000 to students ID's
       gender, 
	   FirstName + ' ' + LastName AS [name]
INTO dsuser29.students
FROM dbo.Students


SELECT * 
INTO dsuser29.Persons
FROM dsuser29.teachers


INSERT INTO dsuser29.Persons
SELECT * FROM dsuser29.students

SELECT * FROM dsuser29.Persons
