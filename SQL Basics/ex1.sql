-- Find the titles of all movies directed by Steven Spielberg.
SELECT title 
FROM Movie 
WHERE director = 'Steven Spielberg'

-- Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT year 
FROM Movie 
WHERE mID IN
(SELECT mID FROM RATING WHERE STARS >= 4) 
ORDER BY YEAR ASC

-- Find the titles of all movies that have no ratings.
SELECT title 
FROM Movie 
WHERE mID NOT IN 
(SELECT mID FROM RATING)

-- Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.
SELECT Name 
FROM Reviewer 
WHERE rID IN 
(SELECT rID  FROM Rating WHERE ratingDate IS NULL)

-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
SELECT  DISTINCT Rv.Name, M.Title, R.Stars, R.ratingDate 
FROM Reviewer Rv, Movie M, Rating R
WHERE R.rID = Rv.rID 
AND M.mID = R.mID 
ORDER BY Rv.Name, M.Title, R.Stars

-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.
SELECT Reviewer.name, Movie.title
FROM Rating R1, Rating R2, Reviewer, Movie
WHERE R1.rID= R2.rID
AND R1.RatingDate < R2.RatingDate
AND R1.mID = R2.mID
AND R1.stars < R2.stars
AND R1.mID = movie.mID
AND R1.rID = reviewer.rID;

-- For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.
SELECT title, MAX(Stars)
FROM Movie, Rating
USING (mId)
GROUP BY title
ORDER BY title

-- For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
SELECT title, MAX(Stars) - MIN(Stars) AS rating_spread
FROM Movie, Rating
USING (mId)
GROUP BY title
ORDER BY rating_spread DESC, title
