-----1  ABORT
SELECT county, COUNT(county) AS months_above_avg 

                     FROM unemployment
					 
WHERE value > (SELECT avg(value) FROM unemployment)
                     GROUP BY county
                     ORDER BY months_above_avg desc;
--------
--------


SELECT county, ROUND(AVG(new_jobs),0) AS avg_new_job
      FROM (SELECT company, MAX(capital_investment) AS lgst_cap_investment
FROM ECD
        WHERE capital_investment IS NOT NULL 
     GROUP BY company, capital_investment
     ORDER BY lgst_cap_investment DESC)
  INNER JOIN ECD
               USING (company)
               GROUP BY county
			   ORDER BY AVG(new_jobs) desc;


SELECT county, 
FROM (SELECT company, MAX(capital_investment)AS max_investment
     FROM ecd
     GROUP BY company) AS max_invest_table 
     INNER JOIN ecd ON max_invest_table.company = ecd.company AND max_invest_table.max_investment = ecd.capital_investment
 ORDER BY ecd.company;
			 


