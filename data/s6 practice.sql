---Write a CTE called top_gold_winter to find the top 5 gold-medal-winning countries for winter games in the database. Then write query to select the countries and the number of medals from the CTE where the total gold medals won is greater than or equal to 5.


WITH top_gold_winter AS 
     (SELECT country, COUNT(gold) as gold_count
FROM winter_games 
	                                                                                      									  
	  INNER JOIN countries ON winter_games.country_id = countries.id
	  WHERE gold IS NOT NULL
									
	  GROUP BY country, 
	  ORDER BY gold_count DESC
	  LIMIT 5) 

SELECT gold_count, country 
FROM top_gold_winter
WHERE gold_count >= 5;

-----answers from chris 
WITH top_five_gold AS ( SELECT country, SUM(gold) AS total_gold
                        FROM winter_games INNER JOIN countries ON winter_games.country_id = countries.id
						GROUP BY country
						ORDER BY total_gold DESC NULLS LAST 
						LIMIT 5)
SELECT *
FROM top_five_gold
WHERE total_gold > 5;
								
---Write a CTE called tall_athletes to find the athletes in the database who are taller than the average height for all athletes in the database. Next query that data to get just the female athletes who are taller than the average height for all athletes and are over the age of 30.



WITH tall_athletes AS (SELECT * FROM athletes
                                WHERE height > (SELECT AVG(height) FROM athletes))

SELECT gender,height
FROM tall_athletes
WHERE gender = 'F' AND age > 30
ORDER BY age DESC;
	 

-----answer from chris
WITH tall_athletes AS (SELECT  *
                         FROM athletes
                          WHERE height > (SELECT AVG(height)
                                                     FROM athletes))
SELECT *
FROM tall_athletes



---Write a CTE called tall_over30_female_athletes that returns the final results of exercise 2 above. Next query the CTE to find the average ---weight for the over 30 female athletes.



WITH tall_over30_female_athletes AS (SELECT *
                                         FROM athletes
                                            WHERE height > (SELECT AVG(height) FROM athletes) 
								               AND  gender = 'F' AND age > 30)                        
						               
																
SELECT ROUND(AVG(weight) , 0)                                         
FROM tall_over30_female_athletes; 
	 