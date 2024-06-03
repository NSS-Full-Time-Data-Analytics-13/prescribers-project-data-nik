SELECT * FROM cbsa;

SELECT * FROM drug;

SELECT * FROM fips_county;

SELECT * FROM overdose_deaths;

SELECT * FROM population;

SELECT * FROM prescriber;

SELECT * FROM prescription;

SELECT * FROM zip_fips;




-- 1.
-- How many npi numbers appear in the prescriber table but not in the prescription table?
SELECT 
	COUNT(DISTINCT p1.npi),
	COUNT(DISTINCT p2.npi) 
FROM prescriber p1  
	FULL JOIN prescription p2
		USING(npi)




-- 2a.
-- Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Family Practice.
SELECT 
	generic_name AS drug,
	SUM(total_claim_count) AS generic_count
FROM prescriber p1
	INNER JOIN prescription p2
		USING(npi)
	INNER JOIN drug d
		USING(drug_name)
WHERE specialty_description ILIKE '%family practice%'
GROUP BY generic_name
ORDER BY generic_count DESC
LIMIT 5;


-- 2b.
-- Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Cardiology.
SELECT 
	generic_name AS drug,
	SUM(total_claim_count) AS generic_count
FROM prescriber p1
	INNER JOIN prescription p2
		USING(npi)
	INNER JOIN drug d
		USING(drug_name)
WHERE specialty_description ILIKE '%cardiology%'
GROUP BY generic_name
ORDER BY generic_count DESC
LIMIT 5;


-- 2c.
-- Which drugs are in the top five prescribed by Family Practice prescribers and Cardiologists? 
-- Combine what you did for parts a and b into a single query to answer this question.
(SELECT 
	specialty_description,
	generic_name AS drug,
	SUM(total_claim_count) AS generic_count
FROM prescriber p1
	INNER JOIN prescription p2
		USING(npi)
	INNER JOIN drug d
		USING(drug_name)
WHERE specialty_description ILIKE '%family practice%'
GROUP BY generic_name, specialty_description
ORDER BY generic_count DESC)
UNION ALL
(SELECT 
	specialty_description,
	generic_name AS drug,
	SUM(total_claim_count) AS generic_count
FROM prescriber p1
	INNER JOIN prescription p2
		USING(npi)
	INNER JOIN drug d
		USING(drug_name)
WHERE specialty_description ILIKE '%cardiology%'
GROUP BY generic_name, specialty_description
ORDER BY generic_count DESC)
LIMIT 5;



-- 3a.
-- Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee.
-- First, write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs. 
-- Report the npi, the total number of claims, and include a column showing the city.
SELECT 
	npi,
	SUM(total_claim_count),
	nppes_provider_city
FROM prescriber
	INNER JOIN prescription
		USING(npi)
WHERE nppes_provider_city = 'NASHVILLE'
GROUP BY npi, nppes_provider_city
ORDER BY SUM(total_claim_count) DESC
LIMIT 5;


-- 3b.
-- Now, report the same for Memphis.
SELECT 
	npi,
	SUM(total_claim_count),
	nppes_provider_city
FROM prescriber
	INNER JOIN prescription
		USING(npi)
WHERE nppes_provider_city = 'MEMPHIS'
GROUP BY npi, nppes_provider_city
ORDER BY SUM(total_claim_count) DESC
LIMIT 5;


-- 3c.
-- Combine your results from a and b, along with the results for Knoxville and Chattanooga.
(SELECT 
	npi,
	SUM(total_claim_count),
	nppes_provider_city
FROM prescriber
	INNER JOIN prescription
		USING(npi)
WHERE nppes_provider_city = 'NASHVILLE'
GROUP BY npi, nppes_provider_city
ORDER BY SUM(total_claim_count) DESC
LIMIT 5)
UNION
(SELECT 
	npi,
	SUM(total_claim_count),
	nppes_provider_city
FROM prescriber
	INNER JOIN prescription
		USING(npi)
WHERE nppes_provider_city = 'MEMPHIS'
GROUP BY npi, nppes_provider_city
ORDER BY SUM(total_claim_count) DESC
LIMIT 5)
UNION
(SELECT 
	npi,
	SUM(total_claim_count),
	nppes_provider_city
FROM prescriber
	INNER JOIN prescription
		USING(npi)
WHERE nppes_provider_city = 'KNOXVILLE' 
GROUP BY npi, nppes_provider_city
ORDER BY SUM(total_claim_count) DESC
LIMIT 5)
UNION
(SELECT 
	npi,
	SUM(total_claim_count),
	nppes_provider_city
FROM prescriber
	INNER JOIN prescription
		USING(npi)
WHERE nppes_provider_city = 'CHATTANOOGA' 
GROUP BY npi, nppes_provider_city
ORDER BY SUM(total_claim_count) DESC
LIMIT 5)




-- 4.
-- Find all counties which had an above-average number of overdose deaths. Report the county name and number of overdose deaths.
SELECT 
	county,
	overdose_deaths
FROM fips_county
	FULL JOIN overdose_deaths
		ON fips_county.fipscounty::integer = overdose_deaths.fipscounty
WHERE overdose_deaths > (SELECT AVG(overdose_deaths) FROM overdose_deaths)




-- 5a.
-- Write a query that finds the total population of Tennessee.


-- 5b.
-- Build off of the query that you wrote in part a to write a query that returns for each county that county's name, its population, and the percentage of the total population of Tennessee that is contained in that county.

