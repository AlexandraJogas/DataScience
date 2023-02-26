USE COLLEGE


/* ************************************************** */
/* ************************************************** */
/* *******    ANALYTICAL FUNCTIONS           ******** */
/* ************************************************** */
/* ************************************************** */

/*
SELECT
[ ROW_NUMBER() | RANK() | DENSE_RANK() | NTILE(n)] | 
[ FIRST_VALUE(<val>) | LAST_VALUE(<val>) | CUME_DIST() | PERCENT_RANK() ]
OVER (
[ PARTITION BY var ]
ORDER BY var [ ASC | DESC ]
[ [ ROWS | RANGE ] [UNBONDED | BETWEEN ] [CURRENT | 
n PRECEDING | n FOLLOWING] [AND [CURRENT | n PRECEDING | 
n FOLLOWING] ] ]
) FROM mytable
*/

SELECT *
	  ,ROW_NUMBER() OVER (ORDER BY Grades DESC) AS rownum
FROM dbo.Classrooms
--ORDER BY Grades;


--- row count for each CourseId by courseId
SELECT *
	  ,ROW_NUMBER() OVER (PARTITION BY CourseId ORDER BY StudentId) AS rownum
FROM dbo.Classrooms;

SELECT *
	  ,ROW_NUMBER() OVER (PARTITION BY CourseId ORDER BY Grades DESC) AS rownum
FROM dbo.Classrooms;


SELECT StudentId,
	  ROW_NUMBER() OVER (PARTITION BY CourseId ORDER BY Grades DESC) AS rownum,
	  CourseId,
	  Grades
FROM dbo.Classrooms;


--- rank by CourseId
SELECT *
	  ,RANK() OVER (ORDER BY StudentId) AS rownum
FROM dbo.Classrooms;

SELECT *
	  ,RANK() OVER (ORDER BY CourseId) AS rownum
FROM dbo.Classrooms;



--- dense rank by courseId
SELECT *
	  ,DENSE_RANK() OVER (ORDER BY StudentId) AS rownum
FROM dbo.Classrooms;


SELECT *
	  ,DENSE_RANK() OVER (ORDER BY CourseId) AS rownum
FROM dbo.Classrooms;



--- ntile (divide in n groups) by courseId
SELECT *
	  ,NTILE(4) OVER (ORDER BY CourseId) AS rownum
--INTO #four
FROM dbo.Classrooms;

SELECT rownum, count(1) as cnt
FROM #four
GROUP BY rownum
ORDER BY rownum

DROP TABLE #four

SELECT *
	  ,NTILE(100) OVER (ORDER BY CourseId) AS rownum
FROM dbo.Classrooms;



SELECT *
	  ,NTILE(4) OVER (ORDER BY Grades) AS categories
	  ,ROW_NUMBER() OVER (ORDER BY Grades) AS rownum
INTO #four
FROM dbo.Classrooms
ORDER BY NTILE(4) OVER (ORDER BY Grades)

--- firts and last value of Grades by order by StudentId

SELECT *
	  ,FIRST_VALUE(Grades) OVER (PARTITION BY StudentId ORDER BY StudentId) AS firstGrade
	  ,LAST_VALUE(Grades) OVER (PARTITION BY StudentId ORDER BY StudentId)  AS lastGrade
FROM dbo.Classrooms;

SELECT DISTINCT categories,
       FIRST_VALUE(rownum) OVER (PARTITION BY categories ORDER BY categories) AS [first_row],
       LAST_VALUE(rownum) OVER (PARTITION BY categories ORDER BY categories) AS [last_row]
FROM #four


--- Cummulative distribution and percent rank of CourseId by order by CourseId
SELECT *
	  ,CUME_DIST() OVER (PARTITION BY StudentId ORDER BY Grades) AS cummDist
	  ,PERCENT_RANK() OVER (PARTITION BY StudentId ORDER BY Grades)  AS pctRnk
FROM dbo.Classrooms
ORDER BY StudentId, Grades;

--------------------------
---- LAG / LEAD
--------------------------

SELECT *
	  ,LAG(Grades) OVER (PARTITION BY CourseId ORDER BY StudentId) AS prevQty
	  ,LAG(Grades,5) OVER (PARTITION BY CourseId ORDER BY StudentId) AS prev5Qty
	  ,LEAD(Grades,3) OVER (PARTITION BY CourseId ORDER BY StudentId)  AS next3Qty
FROM dbo.Classrooms
ORDER BY YEAR(StudentId);



/* ************************************************** */
/* ************************************************** */
/* *******       PIVOT / UNPIVOT             ******** */
/* ************************************************** */
/* ************************************************** */

----- PIVOT 


GO
--------------------------------------------------------------------
---- PIVOT / UNPIVOT 
--------------------------------------------------------------------
--DROP VIEW dbo.StudentCourseGrades_V

GO

CREATE VIEW dbo.StudentCourseGrades_V
AS
SELECT a.StudentId, 
	   b.FirstName + ' ' + b.LastName AS StudentName, 
	   ROUND(a.Grades,1) AS Grades,
	   c.CourseName
FROM dbo.Classrooms AS a
INNER JOIN dbo.Students AS b
  ON a.StudentId = b.StudentId
INNER JOIN dbo.Courses AS c
  ON a.CourseId = c.CourseId
WHERE CourseName LIKE '%ENGLISH%'



SELECT * 
FROM dbo.StudentCourseGrades_V;

GO

-- DROP TABLE #grades_by_courses
SELECT * --StudentName, Grades, CourseName
INTO #grades_by_courses
FROM  dbo.StudentCourseGrades_V
PIVOT (
  AVG(Grades)
  FOR CourseName 
  IN ([English Begginers],[Advanced English],[Proffesional English])
) AS CoursePivot;



SELECT * FROM #grades_by_courses

SELECT StudentId, StudentName, CourseName, Grades
FROM (
	SELECT StudentId, StudentName, [English Begginers],[Advanced English],[Proffesional English]
	FROM #grades_by_courses
	) AS p
UNPIVOT
	( Grades FOR CourseName IN
		([English Begginers],[Advanced English],[Proffesional English])
	) AS unpvt;


SELECT StudentId, StudentName, CourseName, Grades
FROM #grades_by_courses AS p
UNPIVOT
	( Grades FOR CourseName IN
		([English Begginers],[Advanced English],[Proffesional English])
	) AS unpvt;


