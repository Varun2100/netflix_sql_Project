-- NETFLIX PROJECT 

CREATE TABLE netflix
(
 show_id VARCHAR(6),
 type VARCHAR(10),
 title VARCHAR(150),
 director VARCHAR(208),
 castS   VARCHAR(1000),
 country VARCHAR(150),
 date_added VARCHAR(50),
 release_year INT,
 rating VARCHAR(10),
 duration VARCHAR(15),
 listed_in VARCHAR(100),
 description VARCHAR(250)
);

select * from netflix;

select count(*) as Total_Counts
FROM netflix;

select 
DISTINCT TYPE
FROM netflix;

 __ 15 Business Problems

 --1) Count the Number of MOvies VS TV shows

 SELECT 
 type,
 Count(*) as Total_Counts
 FROM netflix
 GROUP BY type;

 --2) FIND THE MOST COMMON RATING FOR MOVIES AND TV SHOWS

 SELECT 
 type,
 rating
FROM 
 
 (
 SELECT 
 type,
 rating,
 COUNT(*),
 RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS RANKING
 FROM netflix
 GROUP BY 1 ,2
 ) AS T1

 WHERE ranking=1

 --3) LIST ALL THE MOVIES RELEASES IN A SPECIFIC YEAR 2020

 SELECT * FROM netflix
 WHERE
 type ='movie'
 AND
 release_year = 2020;
 
--4) FIND THE TOP 5 COUNTRIES WITH THE MOST CONTENT ON NETFLIX

SELECT 
UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--5) Identify the longest movie

SELECT * FROM netflix
WHERE
    type='Movie'
	 AND
	 duration=(SELECT MAX(duration) FROM netflix)

--6) FIND CONTENT ADDED IN THE LAST 5 YEARS

SELECT * FROM netflix
WHERE
TO_DATE(date_added,'Month dd,YYYY')>=CURRENT_DATE-INTERVAL '5 years'

--7)FIND ALL THE MOVIES/TV SHOWS BY DIRECTOR 'Rajiv Chilaka'

SELECT * FROM netflix
where director ILIKE '%Rajiv chilaka'

--8)LIST all the tv shows with more than 5 Seasons

SELECT * FROM netflix
WHERE
  type='TV Show'
    AND 
  SPLIT_PART(duration,' ',1)::numeric > 5

 --9) Count the number of content items in each genre

SELECT 
UNNEST(STRING_TO_ARRAY(listed_in, ',')) as Genre,
COUNT(show_id) as Total_content
FROM netflix
GROUP BY 1

--10)Find each year the average numbers of content release in India on netflix.
-- Return top 5 year with avg content release

SELECT
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
  COUNT(*) as yearly_content,
  ROUND(
  COUNT(*)::numeric/(SELECT  COUNT(*) FROM netflix WHERE country='India')::numeric *100,2) AS avg_content_per_year
     FROM netflix
	 WHERE country='India'
	 GROUP BY 1

--11)List all the movies that are documentarties.

  SELECT * FROM netflix
  WHERE listed_in ILIKE '%documentaries%'

--12)FIND ALL CONTENT WITHOUT A DIRECTOR.

SELECT * FROM netflix
WHERE director IS NULL;

--13) Find how may movies actor 'Salman khan' appeared in last 10 years.


SELECT * FROM netflix
WHERE
  casts ILIKE '%Salman Khan%'
  AND
  release_year > EXTRACT(YEAR FROM CURRENT_DATE)- 10

 --14) FIND THE TOP 10 ACTORS WHO HAVE APPEARED IN THE HIGHEST NUMBER OF MOVIES PRODUCED IN INDIA.

 SELECT 
 UNNEST(STRING_TO_ARRAY(casts, ',')) as Actors,
 COUNT(*) AS Total_content
 FROM netflix
 WHERE country ILIKE '%india%'
 GROUP BY 1
 ORDER BY 2 DESC
  LIMIT 10;

 --15) Catogerize the content based on the presence of the keywords 'kill' and 'voilence' in the description field.Label content containing these 
  --    keywords'bad' and all other content as 'Good'. Count how many items fall into each catogory.


WITH new_table
AS
(
  SELECT
  *,
  CASE 
  WHEN
  description ILIKE '%kill%' OR
  description ILIKE '%voilence%' then 'Bad Content'
  ELSE 'Good Content'
  END AS Category
  FROM netflix
  )
  SELECT 
  Category,
  COUNT(*) AS Total_Content
  FROM new_table
  GROUP BY 1
  


 