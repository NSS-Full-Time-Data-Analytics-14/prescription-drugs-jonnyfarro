


--1.

SELECT DISTINCT county,
       MAX(population) OVER(PARTITION BY county ) AS max_pop,
	   MIN(population) OVER(PARTITION BY county ) AS min_pop
FROM population
ORDER BY max_pop desc

--2.

SELECT year,county,population,
             RANK()OVER(PARTITION BY year ORDER BY MAX(population)DESC )

FROM population 

GROUP BY year,county,population;





--3.
SELECT year,period_name,county,
 
     ROUND(AVG(value)OVER(PARTITION BY county ORDER BY year,period ROWS BETWEEN 11 PRECEDING AND CURRENT ROW), 2) AS     rolling_avg_by_month

FROM unemployment
ORDER BY county,year










