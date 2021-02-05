-- Find the names of all students who are friends with someone named Gabriel.
SELECT H1.name
FROM Highschooler H1
INNER JOIN Friend ON H1.ID = Friend.ID1
INNER JOIN Highschooler H2 ON H2.ID = Friend.ID2
WHERE H2.name = 'Gabriel';

-- For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.
SELECT H1.Name, H1.Grade, H2.Name, H2.Grade
FROM Highschooler H1
INNER JOIN Likes ON H1.ID = Likes.ID1
INNER JOIN Highschooler H2 ON H2.ID = Likes.ID2
WHERE H1.GRADE >= (H2.GRADE + 2)

-- For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.
SELECT H1.Name, H1.Grade, H2.Name, H2.Grade
FROM Highschooler H1
INNER JOIN Likes L1 ON H1.ID = L1.ID1
INNER JOIN Highschooler H2 ON L1.ID2 = H2.ID
INNER JOIN Likes L2 ON H2.ID = L2.ID1
WHERE L2.ID2 = H1.ID AND H1.name < H2.name

-- Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
SELECT Name, Grade
FROM HighSchooler
WHERE ID NOT IN( 
SELECT ID1
FROM Likes
UNION
SELECT ID2
FROM Likes)

-- For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.
SELECT H1.Name, H1.Grade, H2.Name, H2.Grade
FROM Highschooler H1
INNER JOIN Likes ON H1.ID = Likes.ID1
INNER JOIN Highschooler H2 ON H2.ID = Likes.ID2
WHERE H2.ID NOT IN(
SELECT ID1 FROM Likes)

-- Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.
SELECT H.Name, H.Grade
FROM Highschooler H
WHERE ID NOT IN(
SELECT H1.ID 
FROM Highschooler H1
INNER JOIN Friend ON H1.ID = Friend.ID1
INNER JOIN Highschooler H2 ON H2.ID = Friend.ID2
WHERE H1.Grade <>H2.Grade )
ORDER BY H.Grade, H.Name

-- For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.
SELECT DISTINCT H1.Name, H1.Grade, H2.Name, H2.Grade, H3.Name, H3.Grade
FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes L, Friend F1, Friend F2
WHERE (H1.ID = L.ID1 AND H2.ID = L.ID2) AND H2.ID NOT IN (
  SELECT ID2
  FROM Friend
  WHERE ID1 = H1.ID
) 
AND (H1.ID = F1.ID1 AND H3.ID = F1.ID2) 
AND (H2.ID = F2.ID1 AND H3.ID = F2.ID2);

--Find the difference between the number of students in the school and the number of different first names.
SELECT COUNT(*) - COUNT(DISTINCT name)
FROM Highschooler;

--Find the name and grade of all students who are liked by more than one other student.
SELECT Name, Grade
FROM Highschooler
INNER JOIN Likes ON Highschooler.ID = Likes.ID2
GROUP BY Name,Grade
HAVING COUNT(*) > 1;

