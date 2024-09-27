WITH first_release  AS (SELECT domestic_distributor_id,MIN(release_year) AS first_year
                        FROM specs
                        WHERE domestic_distributor_id IS NOT NULL
                        GROUP BY domestic_distributor_id)
SELECT (release_year - first_year) AS years_active , AVG(film_budget):: money AS budget,AVG(worldwide_gross)::money AS gross 
FROM first_release INNER JOIN specs USING(domestic_distributor_id)
                   INNER JOIN revenue USING (movie_id)

GROUP BY release_year - first_year 
ORDER by years_active 
----treats first_release at a new table. 
