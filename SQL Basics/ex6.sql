-- It's time for the seniors to graduate. Remove all 12th graders from Highschooler.

DELETE FROM HighSchooler
WHERE Grade = '12'

-- If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.

DELETE FROM Likes
WHERE ID1 IN( SELECT ID1 
			FROM Likes L1
			WHERE ID1 NOT IN( 
					SELECT ID2
    				FROM Likes L2
					WHERE L2.ID1 =L1.ID2)
			and ID1 IN(
					SELECT ID2
					FROM Friend F
					WHERE F.ID1 = L1.ID2))

-- For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.)

INSERT INTO Friend
SELECT DISTINCT H1.ID, H3.ID
FROM HighSchooler H1, HighSchooler H2, Friend F1, Friend F2, HighSchooler H3
WHERE (H1.ID = F1.ID1 AND F1.ID2 = H2.ID) AND (H2.ID = F2.ID1 AND F2.ID2 = H3.ID)
    AND (H1.ID<> H3.ID) AND H1.ID NOT IN(SELECT F3.ID2 FROM Friend F