-- Find the names of all reviewers who rated Gone with the Wind.
SELECT DISTINCT Name
FROM Movie
INNER JOIN Rating USING(mId)
INNER JOIN Reviewer USING(rId)
WHERE title = 'Gone with the Wind';

-- For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
SELECT name, title, stars
FROM Movie
INNER JOIN Rating USING (mId)
INNER JOIN Reviewer USING (rId)
WHERE director = name;

-- Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)
SELECT title FROM Movie
UNION
SELECT name FROM Reviewer

-- Find the titles of all movies not reviewed by Chris Jackson.
SELECT title 
FROM Movie
WHERE mId NOT IN(
  SELECT mId
  FROM Rating
  INNER JOIN Reviewer USING(rId)
  WHERE name = 'Chris Jackson'
);

-- For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
SELECT DISTINCT Rv1.name, Rv2.name
FROM Rating R1, Rating R2, Reviewer Rv1, Reviewer Rv2
WHERE R1.mID = R2.mID
AND R1.rID = Rv1.rID
AND R2.rID = Rv2.rID
AND Rv1.name < Rv2.name
ORDER BY Rv1.name, Rv2.name;

-- For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
SELECT name, title, stars
FROM Movie
INNER JOIN Rating USING (mId)
INNER JOIN Reviewer USING (rId)
WHERE Stars = (SELECT MIN(Stars) FROM Rating)

-- List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.
SELECT title, AVG(stars) AS AVGStar
FROM Movie
INNER JOIN Rating USING (mId)
GROUP BY title
ORDER BY AVGStar DESC

-- Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)
SELECT name
FROM Reviewer
INNER JOIN Rating USING(rID)
GROUP BY name
HAVING COUNT(rID) >= 3

--Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)
SELECT M1.title, M1.director
FROM Movie M1
INNER JOIN Movie M2 USING(director)
WHERE M1.mID <> M2.mID
ORDER BY M1.director, M1.title

--Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)
SELECT title, AVG(stars)
FROM MOVIE
INNER JOIN RATING using(mid)
GROUP BY movie.mID, title
HAVING  AVG(stars) = (
	SELECT MAX(avg_stars)
	FROM (
		SELECT title, AVG(stars) AS avg_stars
		FROM MOVIE
		INNER JOIN RATING USING(mID)
		GROUP BY title
		) AS A1
);

--Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)
SELECT title, AVG(stars)
FROM MOVIE
INNER JOIN RATING using(mid)
GROUP BY title
HAVING  AVG(stars) = (
	SELECT MIN(avg_stars)
	FROM (
		SELECT title, AVG(stars) AS avg_stars
		FROM MOVIE
		INNER JOIN RATING USING(mID)
		GROUP BY title
		) AS A1
);

--For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.
SELECT director, title, MAX(Stars)
 FROM Movie
 INNER JOIN Rating USING (mID)
 WHERE Director IS NOT NULL
 GROUP BY director