USE COLLEGE


/* *******************************************

               JOINING TABLES

********************************************** */

--- INNER JOIN

SELECT * FROM dbo.Classrooms
SELECT * FROM dbo.Students

SELECT *
FROM       dbo.Classrooms     AS table1
INNER JOIN dbo.Students       AS table2
ON table1.StudentId = table2.StudentId


SELECT table1.CourseId,  table1.StudentId, table1.Grades, 
       table2.FirstName, table2.LastName,  table2.Gender
FROM       dbo.Classrooms AS table1
INNER JOIN dbo.Students AS table2
ON table1.StudentId = table2.StudentId

/*SELECT * FROM dbo.Courses*/

SELECT *
FROM       dbo.Classrooms AS table1
INNER JOIN dbo.Students   AS table2
   ON table1.StudentId = table2.StudentId
INNER JOIN dbo.Courses    AS table3
   ON table1.CourseId  = table3.CourseId


SELECT table3.CourseName, table1.StudentId, table2.FirstName, table2.LastName, table1.Grades
FROM       dbo.Classrooms AS table1
INNER JOIN dbo.Students   AS table2
   ON table1.StudentId = table2.StudentId
INNER JOIN dbo.Courses    AS table3
   ON table1.CourseId = table3.CourseId


SELECT *
FROM       dbo.Classrooms AS table1
INNER JOIN dbo.Students   AS table2
   ON table1.StudentId = table2.StudentId
INNER JOIN dbo.Courses    AS table3
   ON table1.CourseId = table3.CourseId
INNER JOIN dbo.Departments AS table4
   ON table3.DepartmentID = table4.DepartmentId
INNER JOIN dbo.Teachers AS table5
   ON table3.TeacherId = table5.TeacherId


---- LEFT OUTER JOIN

--- select only the first 100 students on the table
-- drop table dsuser28.Students100
SELECT TOP 100 *
INTO dsuser02.Students100_sql3
FROM dbo.Students

SELECT * FROM dbo.Classrooms
SELECT * FROM dsuser02.Students100_sql3
--- check how many students we have while joining the classroom to this list
SELECT *
FROM       dbo.Classrooms            AS table1
INNER JOIN dsuser02.Students100_sql3 AS table2
   ON table1.StudentId = table2.StudentId
order by table1.StudentId

--- now check how many rows we get from left outer join
SELECT *
FROM            dbo.Classrooms            AS table1
LEFT OUTER JOIN dsuser02.Students100_sql3 AS table2
   ON table1.StudentId = table2.StudentId
order by table2.StudentId

----- RIGHT OUTER JOIN
SELECT *
FROM             dbo.Classrooms            AS table1
RIGHT OUTER JOIN dsuser02.Students100_sql3 AS table2
   ON table1.StudentId = table2.StudentId
order by table1.StudentId

---- FULL OUTER JOIN

SELECT *
FROM            dbo.Classrooms            AS table1
FULL OUTER JOIN dsuser02.Students100_sql3 AS table2
   ON table1.StudentId = table2.StudentId
order by table1.StudentId, table2.StudentId

---- UNION
Id	FirstName	LastName	productID

SELECT DISTINCT StudentId, FirstName, LastName, DepartmentId, DeprtmentName
INTO dsuser02.Bank_sql3
FROM (
	SELECT * 
	FROM dbo.Students
	   UNION ALL
	SELECT *
	FROM dbo.Courses
	UNION ALL
	SELECT * FROM dbo.Departments
) AS a

----------------------------------------
-----   EXERCISE
----------------------------------------

--- CREATE A TABLE IN YOUR OWN SCHEMA BY JOINING THE Students, Classrooms and Courses TABLES. 
--- THE TABLE MUST CONTAIN: Course name, Student name, Student gender, and class grades. 
--- CALL THE NEW TABLE 'grades' 

SELECT	table1.CourseId, 
		table3.CourseName, 
		table1.StudentId, 
		table2.FirstName, 
		table2.LastName, 
		table2.Gender,
		table1.Grades
INTO dsuser02.grades_sql3
FROM       dbo.Classrooms AS table1
INNER JOIN dbo.Students   AS table2
   ON table1.StudentId = table2.StudentId
INNER JOIN dbo.Courses    AS table3
   ON table1.CourseId = table3.CourseId

SELECT * FROM dsuser02.grades_sql3
order by CourseId, StudentId
/* *******************************************

            DATATYPES CONVERSION

********************************************** */b

---- CAST( var1 AS VARCHAR(20) )

SELECT '1234.2', CAST('1234.2' AS FLOAT)

SELECT (2564.0/21), CAST((2564.0/21) AS CHAR(10))

---- CONVERT(VARCHAR(20), var1)

SELECT '1234.2', CONVERT(FLOAT, '1234.2')

SELECT 100*1.0/7, 100/7


SELECT StudentId, CAST(StudentId AS INT)/ 7 AS StdId7a, CAST(StudentId AS INT)*1.0 / 7 AS StdId7
FROM dbo.Students

SELECT StudentId, CAST(StudentId AS INT) AS StdId_int, CAST(StudentId AS INT)*1.0  AS StdId_float
FROM dbo.Students


SELECT StudentId, CAST(StudentId AS INT)*1.0 / 7                  AS StdId7a,
             CAST(CAST(StudentId AS INT)*1.0 / 7 AS DECIMAL(6,2)) AS StdId7,
			      CAST(StudentId  AS DECIMAL(6,2))                AS StdId7b
FROM dbo.Students

--- Dates
SELECT '2001-12-20', CAST('2001-12-20' AS DATE),     CONVERT(DATE,     '2001-12-20')
SELECT '2001-12-20', CAST('2001-12-20' AS DATETIME), CONVERT(DATETIME, '2001-12-20')
SELECT '20011220',   CAST('20011220'   AS DATETIME), CONVERT(DATETIME, '20011220')

SELECT '06/21/2021', CAST('06/21/2021' AS DATETIME), CONVERT(DATETIME, '06/21/2021')
SELECT '21/06/2021', CAST('21/06/2021' AS DATETIME), CONVERT(DATETIME, '21/06/2021')
SELECT '21/06/2021', CONVERT(DATETIME, '05-06-2021', 105), CONVERT(date,'05-06-2021', 105)

SELECT '12/21/2021', CAST('12/21/2021' AS DATETIME), CAST(CAST('12/21/2021' AS DATETIME) AS VARCHAR(50))
SELECT '12/21/2021', CAST('12/21/2021' AS DATETIME), CONVERT(DATETIME, '12/21/2021')

SELECT '12/21/2021', CAST('12/21/2021' AS DATETIME), CONVERT(VARCHAR(12), CAST('12/21/2021' AS DATETIME) ,113)

/* *******************************************

            AGGREGATIONS

********************************************** */

SELECT COUNT(1) FROM dbo.Students

SELECT DISTINCT * FROM dbo.Students

SELECT DISTINCT(GENDER) FROM dbo.Students
SELECT GENDER FROM dbo.Students

SELECT GENDER, 
       COUNT(1) AS cnt
FROM dbo.Students
GROUP BY GENDER

--- get the mean, minimum and maximum grades, number of students and number of females on each course.
SELECT  CourseId,
		COUNT(1)    AS num_students,
		COUNT(DISTINCT StudentId) AS students,
		AVG(Grades) AS grades_mean,
		MIN(Grades) AS grades_min,
		MAX(Grades) AS grades_max
FROM dbo.Classrooms
GROUP BY CourseId


--- get the mean for males and for women independently as columns for each course. 
--- The mean must be shown with only two decimals
SELECT  CourseName ,
		ROUND(AVG( CASE WHEN (Gender = 'F') THEN (Grades) END ),2) AS female_grades_mean,
		ROUND(AVG( CASE WHEN (Gender = 'M') THEN (Grades) END ),2) AS male_grades_mean
FROM dsuser02.grades_sql3
GROUP BY CourseName

SELECT  CourseName , Gender,
		AVG( Grades ) AS grades_mean
FROM dsuser02.grades_sql3
GROUP BY CourseName, Gender
order by CourseName, Gender




/* *******************************************

            SUBQUERIES

********************************************** */

--- In we need only to retrieve the grades of the female students, but we don't need to add
--- the columns from the students table, we can use subqueries...

SELECT *
FROM dbo.Classrooms
WHERE StudentId IN (1,3,130,210)

SELECT * FROM Students


SELECT *
FROM dbo.Classrooms
WHERE StudentId IN (	
	SELECT StudentId FROM dbo.Students WHERE Gender = 'M' AND FirstName like '%sh%'
) 

SELECT *
FROM dbo.Classrooms
WHERE StudentId IN (43, 222)


--- Now, we will bring the grades for the course 'SQL'

SELECT *
FROM dbo.Classrooms
WHERE CourseId IN (	
	select CourseId from Courses where CourseName LIKE '%SQL%'
)

SELECT *
FROM dbo.Classrooms
WHERE CourseId IN (	
	select CourseId from Courses where CourseName LIKE '%Engl%'
)

---- We can also bring subqueries as a variables, if the result for the query has only one unique result
SELECT * FROM dbo.Students    order by StudentId
SELECT * FROM dbo.Classrooms  order by StudentId

SELECT *,
	   (SELECT AVG(Grades) FROM dbo.Classrooms WHERE StudentId = a.StudentId) AS Grades_mean
FROM Students AS a



SELECT *
FROM Classrooms

SELECT * 
FROM Courses

SELECT * 
FROM Departments

SELECT CourseName, Grades 
FROM (
	SELECT b.CourseName, a.StudentId, a.Grades
	FROM       Classrooms a
	INNER JOIN Courses    b
	  ON a.CourseId = b.CourseId
	WHERE b.DepartmentID IN (
			SELECT DepartmentID FROM dbo.Departments WHERE DepartmentName = 'Sport'
			)
) AS t1

/* *******************************************

            VIEWS

********************************************** */

--- We can save the previous query as a view and run it anytime to obtain the most updated results...
GO

CREATE VIEW dsuser02.StudentsGrade_V AS
--ALTER VIEW dsuser02.StudentsGrade_V AS
	SELECT *,
	   (SELECT AVG(Grades)   FROM COLLEGE.dbo.Classrooms AS b WHERE b.StudentId = a.StudentId) AS Grades_mean,
	   (SELECT STDEV(Grades) FROM COLLEGE.dbo.Classrooms AS b WHERE b.StudentId = a.StudentId) AS Grades_sd

	FROM COLLEGE.dbo.Students AS a

SELECT * FROM dsuser02.StudentsGrade_V

DROP VI[dsuser04].[V_TeatherGrades]EW dsuser39.StudentsGrade_V




/* *******************************************

   Exercise: Create a table that shows the following data

   ----------------------------------------------------------------------------------
   | CourseName | TeacherName | NumberOfStudents | AverageGrades (for each corse) |
   ----------------------------------------------------------------------------------

   Create a the table using two different approaches:
   1. Using join between tables
   2. Using subqueries 
   When done, create a view that can be used to recreate the table with updated data when needed.

********************************************** */

SELECT * FROM Courses
SELECT * FROM Teachers
SELECT * FROM Classrooms

SELECT a.CourseName,
       CONCAT(b.FirstName,' ',b.LastName) AS TeacherName,
       COUNT(DISTINCT c.StudentId)        AS NumberOfStudents,
	   AVG(c.Grades)                      AS AverageGrades
FROM            Courses  a
LEFT OUTER JOIN Teachers b
  ON a.TeacherId = b.TeacherId
LEFT OUTER JOIN Classrooms c
  ON a.CourseId = c.CourseId
GROUP BY a.CourseName, CONCAT(b.FirstName,' ',b.LastName)


SELECT a.CourseName, 
       CONCAT(b.FirstName,' ',b.LastName) AS TeacherName,
       COUNT(DISTINCT c.StudentId)        AS NumberOfStudents,
	   AVG(c.Grades)                      AS AverageGrades
FROM Courses a
INNER JOIN Teachers b
  ON a.TeacherId = b.TeacherId
INNER JOIN Classrooms c
  ON a.CourseId = c.CourseId
GROUP BY a.CourseName, CONCAT(b.FirstName,' ',b.LastName)



------------------------------

SELECT * FROM Courses  -- CourseID, CourseName, TeacherId
SELECT * FROM Teachers -- FirstName, LastName
SELECT * FROM Classrooms -- CourseID, StudentID, Grades

SELECT a.CourseName, 
       (SELECT CONCAT(FirstName,' ',LastName) 
	       FROM Teachers WHERE Teachers.TeacherId = a.TeacherId)   AS TeacherName,
	   (SELECT COUNT(1) 
	       FROM Classrooms WHERE Classrooms.CourseId = a.CourseId) AS NumberOfStudents,
	   (SELECT AVG(Grades) 
	       FROM Classrooms WHERE Classrooms.CourseId = a.CourseId) AS AverageGrades
FROM Courses a

GO 
-----------------------------


CREATE  VIEW dsuser02.CoursesGradesList_V AS
SELECT a.CourseName, 
       (SELECT CONCAT(FirstName,' ',LastName) 
	       FROM Teachers WHERE Teachers.TeacherId = a.TeacherId)   AS TeacherName,
	   (SELECT COUNT(1) 
	       FROM Classrooms WHERE Classrooms.CourseId = a.CourseId) AS NumberOfStudents,
	   (SELECT AVG(Grades) 
	       FROM Classrooms WHERE Classrooms.CourseId = a.CourseId) AS AverageGrades
FROM Courses a


SELECT * FROM dsuser02.CoursesGradesList_V