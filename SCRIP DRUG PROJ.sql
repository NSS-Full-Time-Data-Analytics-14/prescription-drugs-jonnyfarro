SELECT COUNT( DISTINCT drug_name)
FROM drug 

SELECT *
FROM drug

SELECT DISTINCT * FROM drug
JOIN prescription on prescription.drug_name = drug.drug_name
JOIN prescription
ON prescriber.npi = prescription.npi;

SELECT * FROM drug
full JOIN prescription
USING (drug_name); 

SELECT * FROM prescriber 


---1a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.

---- ANSWER 1912011792 

SELECT nppes_provider_last_org_name,npi, total_claim_count  
FROM prescription AS p1
FULL JOIN prescriber AS p2
USING (npi)
WHERE total_claim_count IS NOT NULL
ORDER BY total_claim_count DESC
LIMIT 5;  

---b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.
---


SELECT nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, total_claim_count, drug_name 
FROM prescription AS p1
FULL JOIN prescriber AS p2
USING (npi)
WHERE total_claim_count IS NOT NULL
ORDER BY total_claim_count DESC
LIMIT 10;  

-----2a. Which specialty had the most total number of claims (totaled over all drugs)? 
---- AnSWER :FAMILY PRACTICE 

SELECT  specialty_description, total_claim_count
FROM prescription AS p1
FULL JOIN prescriber AS p2
USING (npi)
WHERE total_claim_count IS NOT NULL 
ORDER BY total_claim_count DESC
LIMIT 10;  

--- 2.b ACTIONWhich specialty had the most total number of claims for opioids?
--- NURSE PRACTITIONER
--- 
SELECT specialty_description,total_claim_count, opioid_drug_flag,long_acting_opioid_drug_flag
FROM prescription 
      INNER JOIN prescriber 
      USING (npi)
      INNER JOIN drug
USING (drug_name)
WHERE opioid_drug_flag = 'Y' 
      AND total_claim_count IS NOT NULL
	  AND long_acting_opioid_drug_flag = 'Y'
ORDER BY total_claim_count DESC;


-----2c Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

SELECT DISTINCT (specialty_description), prescription.drug_name 
FROM prescription 
      FULL JOIN prescriber 
      USING (npi)
      FULL JOIN drug
USING (drug_name)
WHERE drug_name is NULL 
ORDER BY drug_name DESC;


SELECT DISTINCT specialty_description 
FROM prescriber
LEFT JOIN prescription
USING (npi)
      



---------------------------
       ------------
---------------------------
SELECT specialty_description
FROM prescriber
LEFT JOIN prescription
USING(npi)
GROUP BY specialty_description
HAVING SUM(total_claim_count) IS NULL;


----2d.


----
----3a a. Which drug (generic_name) had the highest total drug cost? PIRFENIDONE 

   -- b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**

select generic_name, MAX(total_drug_cost) AS highest_total_cost
FROM prescription 
INNER JOIN drug
USING (drug_name)
GROUP BY generic_name
ORDER BY  highest_total_cost DESC ;

SELECT generic_name, 
             ROUND(MAX(total_drug_cost / total_day_supply),2) AS cost_per_day
FROM prescription 
INNER JOIN drug
USING (drug_name)
GROUP BY generic_name, total_day_supply 
ORDER BY  cost_per_day DESC 
LIMIT 10;



----
----
----   a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have           opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other            drugs. **Hint:** You may want to use a CASE expression for this. See https://www.postgresqltutorial.com/postgresql-                          tutorial/postgresql-case/

   --- b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics.             Hint: Format the total costs as MONEY for easier comparision.


SELECT drug_name, 
        		 
	CASE WHEN  opioid_drug_flag = 'Y' THEN 'opioid'
         WHEN antibiotic_drug_flag ='Y' THEN 'antibiotic'
		 ELSE 'neither' END AS drug_type 
		 
		 FROM drug
		 LIMIT 10;

		 
SELECT SUM(total_drug_cost::money) AS money,
      
	  CASE  WHEN opioid_drug_flag = 'Y' THEN 'opioid'
            WHEN antibiotic_drug_flag ='Y' THEN 'antibiotic'
		    ELSE 'neither' END AS drug_type 
      FROM drug
    JOIN prescription
  USING(drug_name)
 GROUP BY opioid_drug_flag,antibiotic_drug_flag
ORDER BY money DESC ;



5.
-----  a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.
----    42
----
---    b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
----
----
----   c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.


---a
SELECT * ---COUNT(cbsa) AS number_of_cbsa_in_TN
FROM cbsa
INNER JOIN fips_county
USING (fipscounty)
WHERE fips_county.state = 'TN';

-----b
(SELECT DISTINCT cbsaname, SUM(population) AS pop_sum
 FROM cbsa
 INNER JOIN population 
 USING (fipscounty)
 INNER JOIN fips_county
 USING(fipscounty)
GROUP BY DISTINCT cbsaname
ORDER BY pop_sum DESC
LIMIT 1)

UNION

(SELECT DISTINCT cbsaname, SUM(population) AS pop_sum
FROM cbsa
          INNER JOIN population 
          USING (fipscounty)
          INNER JOIN fips_county
          USING(fipscounty)
GROUP BY DISTINCT cbsaname
ORDER BY pop_sum ASC
LIMIT 1);

---c
SELECT county,MAX(population)AS max_pop ,cbsa 
FROM fips_county
        RIGHT JOIN cbsa
        USING (fipscounty)
        INNER JOIN population
        USING (fipscounty)
GROUP BY county,population,cbsa
LIMIT 1;

-----c REWORKED---- 
SELECT county, 
          MAX(population) AS highest_population
FROM fips_county
           JOIN population 
	       USING (fipscounty)
		   WHERE fipscounty 
		   NOT IN (SELECT fipscounty FROM cbsa)
	       
		   GROUP BY county,population
	       ORDER by highest_population DESC
	       LIMIT 1 ;


--6a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

SELECT drug_name, total_claim_count
FROM prescription
WHERE total_claim_count >= 3000
ORDER BY total_claim_count DESC;

--6b.For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
  
SELECT drug_name,total_claim_count,
      
	  CASE  WHEN opioid_drug_flag = 'Y' THEN 'opioid'
            ELSE 'neither' END AS drug_type 
			
      FROM drug
      JOIN prescription
      USING(drug_name)
      WHERE  total_claim_count >= 3000
	  ORDER BY total_claim_count DESC;


--6c.Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

SELECT nppes_provider_first_name, nppes_provider_last_org_name, drug_name, total_claim_count,
      
	  CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
            ELSE 'neither' END AS drug_type 
			
      FROM drug
      INNER JOIN prescription
      USING(drug_name)
	  INNER JOIN prescriber AS p
	  USING(npi)
      WHERE  total_claim_count >= 3000
	  GROUP BY nppes_provider_first_name, nppes_provider_last_org_name, drug_name, total_claim_count,drug_type
	  ORDER BY drug_type DESC;
---
---7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

 --   7a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.


SELECT npi, drug_name, 
                         CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
                                                      ELSE 'neither' END AS drug_type           
                        FROM prescriber
                        CROSS JOIN drug
                        WHERE specialty_description = 'Pain Management'
                        AND nppes_provider_city = 'NASHVILLE'
                        AND opioid_drug_flag = 'Y'
GROUP BY npi, drug_name, drug.opioid_drug_flag;


   -- 7b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).

   SELECT CONCAT(p.nppes_provider_first_name,'  ', p.nppes_provider_last_org_name) AS drug_dealer_name,
                                   p.npi, 
			                          d.drug_name,
					                     SUM(scrip.total_claim_count) AS total_claims,
			              CASE WHEN d.opioid_drug_flag = 'Y' THEN 'opioid'
                          ELSE 'neither' END AS drug_type           
    
	FROM prescriber as p
     CROSS JOIN drug as d
     LEFT JOIN prescription as scrip USING (drug_name)
     WHERE specialty_description = 'Pain Management'
     AND nppes_provider_city = 'NASHVILLE'
     AND opioid_drug_flag = 'Y'
	 
GROUP BY p.npi, d.drug_name,d.opioid_drug_flag,p.nppes_provider_first_name,p.nppes_provider_last_org_name
ORDER BY total_claims DESC NULLS LAST;






 


  --  7c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - --Google the COALESCE function





   SELECT 
        COALESCE( scrip.total_claim_count,'0') AS new_total_claim_counts,
             CONCAT(p.nppes_provider_first_name,'  ', p.nppes_provider_last_org_name) AS drug_dealer_name,
             p.npi, 
			 d.drug_name,
					      SUM(scrip.total_claim_count) AS total_claims,
			              CASE WHEN d.opioid_drug_flag = 'Y' THEN 'opioid'
                          ELSE 'neither' END AS drug_type           
    
	FROM prescriber as p
    CROSS JOIN drug as d
    LEFT JOIN prescription as scrip USING (drug_name)
    WHERE specialty_description = 'Pain Management'
    AND nppes_provider_city = 'NASHVILLE'
    AND opioid_drug_flag = 'Y'
	 
GROUP BY p.npi, d.drug_name,d.opioid_drug_flag,p.nppes_provider_first_name,p.nppes_provider_last_org_name,new_total_claim_counts
ORDER BY total_claims DESC NULLS LAST;









