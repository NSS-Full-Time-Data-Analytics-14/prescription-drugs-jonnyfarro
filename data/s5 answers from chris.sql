SELECT county, COUNT(period) AS total_months 
FROM unemployment
WHERE value > (SELECT AVG(value) FROM unemployment)
GROUP BY county
ORDER BY total_months DESC;


SELECT county, 
FROM(SELECT company, MAX(capital_investment)AS max_investment
     FROM ecd
     GROUP BY company) AS max_invest_table 
     INNER JOIN ecd ON max_invest_table.company = ecd.company AND max_invest_table.max_investment = ecd.capital_investment
 ORDER BY ecd.company