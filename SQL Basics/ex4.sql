-- For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C.

SELECT H1.Name, H1.Grade, H2.Name, H2.Grade, H3.Name, H3.Grade
FROM HighSchooler H1, HighSchooler H2, HighSchooler H3, LIKES L1, LIKES L2
WHERE (H1.ID = L1.ID1 AND L1.ID2 = H2.ID) AND (H2.ID = L2.ID1 AND L2.ID2 = H3.ID)
AND H3.ID <> H1.ID

-- Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades.

SELECT Name, Grade
FROM HighSchooler H1
WHERE Grade NOT IN(
SELECT H2.Grade 
FROM HighSchooler H2
INNER JOIN Friend F
ON H2.ID = F.ID1
WHERE F.ID2 = H1.ID)

-- What is the average number of friends per student? (Your result should be just one number.)

SELECT AVG(count)
FROM (
  SELECT COUNT(*) AS Count
  FROM Friend
  GROUP BY ID1
) C

-- Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.

SELECT COUNT(ID2) 
FROM Friend 
WHERE ID1 
IN
(SELECT ID2
FROM Friend F
INNER JOIN HighSchooler H
ON F.ID1 = H.ID
WHERE H.Name = 'Cassandra')

-- Find the name and grade of the student(s) with the greatest number of friends.

SELECT Name, Grade
FROM HighSchooler H
INNER JOIN Friend  F
ON H.ID =F.ID1 
GROUP BY Name,Grade
HAVING COUNT(*) =
(SELECT MAX(Count_Friend) FROM
(SELECT (COUNT(ID2)) AS Count_Friend
FROM Friend
GROUP BY ID1) AS T1)

