-- ------------------------------------------------------------------------------------------- --
-- -------------------------------  STA 690 Midterm Assignment  ------------------------------ --
-- ------------------------------------------------------------------------------------------- --

-- Instructions --

-- Use the Credit relational dataset to answer the following questions. Write your code in this
-- file after each corresponding question and include a comment with the answer to the question
-- if applicable.  Code should use syntax best practices.  







-- 1. Return all columns from the charge table for charges less than $300 --
SELECT
	*
FROM
	charge
WHERE
	charge_amt < 300;

    



-- 2. Return count of members who made a category 3 charge in September --
-- 44448 members --

SELECT DISTINCT
	COUNT(member_no)
FROM
	charge
WHERE
	category_no = 3
    AND MONTH(charge_dt) = 9;
  
  
  
  
  
 -- 3. Among charges from categories 6, 7, 8, and 9 return the average and total charge amounts from the charge table, give the columns aliases --   
 -- Average: 2503.435, Total: 1773473248 --
SELECT
	AVG(charge_amt) AS "Average Charge Amount"
    , SUM(charge_amt) AS "Total Charge Amount"
FROM
	charge
WHERE
	category_no IN (6, 7, 8, 9);
  
  
  
  
    
 -- 4. Return count of all members whose first name ends with 'EY' -- 
 -- Count: 19 --
SELECT
	COUNT(*)
FROM
	member
WHERE
	firstname LIKE '%EY';
    




-- 5. Return average charge amount by month from the charge table --
SELECT
	MONTH(charge_dt)
	, AVG(charge_amt)
FROM
	charge
GROUP BY
	1;





-- 6. Return average charge amount by month from the charge table among charges with category 3, 4, and 6 --
SELECT
	MONTH(charge_dt)
	, AVG(charge_amt)
FROM
	charge
WHERE
	category_no IN (3, 4, 6)
GROUP BY
	1;





-- 7. Return average charge amount by month from the charge table among charges with category 3, 4 and 6. --
-- Include only months that have an average charge amount higher than the entire table's average charge amount --

SELECT
	MONTH(charge_dt)
	, AVG(charge_amt)
FROM
	charge
WHERE
	category_no IN (3, 4, 6)
GROUP BY
	1;



-- 8. Return all columns for charges in September.  Comment how many charges are included in result set --
-- 402512 rows returned --
SELECT
	*
FROM
	charge
WHERE
	MONTH(charge_dt) = 9;



-- 9. Update your question #8 query to include a left join with the statement table --
-- 402512 rows returned --
SELECT
	c.*
FROM
	charge c
    LEFT JOIN statement s
		ON c.statement_no = s.statement_no
WHERE
	MONTH(charge_dt) = 9;





-- 10. Update your question #8 query to include an inner join with the statement table --
-- Comment how many rows are included in your result set and why it differs from your row count in question 9 --
/* 163440 rows returned. Since we are doing an inner join, if there is a statement_no in the charge table that doesn't exist in
the statement table, or vice versa, that row will not show in our final results. This explain why we see fewer rows with the
inner join compared to the left join. */

SELECT
	c.*
FROM
	charge c
    INNER JOIN statement s
		ON c.statement_no = s.statement_no
WHERE
	MONTH(charge_dt) = 9;





-- 11. Return average charge amount per provider region (include region name) ordered from lowest to highest average charge amount --
SELECT
	r.region_name
	, AVG(c.charge_amt) AS "Average charge amount"
FROM
	charge c
    LEFT JOIN provider p
		ON c.provider_no = p.provider_no
	LEFT JOIN region r
		ON p.region_no = r.region_no
GROUP BY
	1
ORDER BY
	2;
    





-- 12. Return total category 10 charges per member region (include region name) ordered from most to least charges --

SELECT
	r.region_name
	, COUNT(c.category_no) AS "Total Charges"
FROM
	charge c
	LEFT JOIN provider p
		ON c.provider_no = p.provider_no
	LEFT JOIN region r
		ON p.region_no = r.region_no
WHERE
	c.category_no = 10
GROUP BY
	1
ORDER BY
	2 DESC;


-- 13. Return all payments that are larger than the largest charge in the charge table and have a payment date in October --

SELECT
	p.*
FROM
	payment p
    LEFT JOIN charge c
		ON p.statement_no = c.statement_no
WHERE
	p.payment_amt > (
		SELECT
			MAX(c.charge_amt)
		FROM
			charge c
	)
    AND MONTH(p.payment_dt) = 10;




-- 14. Return all provider names who have total charge amounts lower than providers 'Prov. Boston Ma' and 'Prov. Apex Petr' --

SELECT
	p.provider_name
FROM
	provider p
    LEFT JOIN charge c
		ON c.provider_no = p.provider_no
GROUP BY
	1
HAVING 
	SUM(c.charge_amt) < ALL (
	SELECT
		SUM(c.charge_amt)
	FROM
		provider p
        LEFT JOIN charge c
			ON c.provider_no = p.provider_no
	WHERE
		p.provider_name IN ("Prov. Boston Ma", "Prov. Apex Petr")
	GROUP BY
		p.provider_name
	)
;
	





-- 15. Using an inner join and a sub query filter the charge table to only charges linked with providers with 'Famous' in their name --

SELECT
	c.*
FROM
	charge c
    INNER JOIN provider p
		ON c.provider_no = p.provider_no
WHERE
	p.provider_no IN (
		SELECT
			provider_no
		FROM
			provider
		WHERE
			provider_name LIKE "%Famous%"
	)
;




-- 16. Return total charge amount per month, please have results in one row --
SELECT
	SUM(CASE WHEN MONTH(charge_dt) = 1 THEN charge_amt 
		ELSE 0 END) AS January,
        
	SUM(CASE WHEN MONTH(charge_dt) = 2 THEN charge_amt 
		ELSE 0 END) AS February,
        
	SUM(CASE WHEN MONTH(charge_dt) = 3 THEN charge_amt 
		ELSE 0 END) AS March,
        
	SUM(CASE WHEN MONTH(charge_dt) = 4 THEN charge_amt 
		ELSE 0 END) AS April,
        
	SUM(CASE WHEN MONTH(charge_dt) = 5 THEN charge_amt 
		ELSE 0 END) AS May,
        
	SUM(CASE WHEN MONTH(charge_dt) = 6 THEN charge_amt 
		ELSE 0 END) AS June,
        
	SUM(CASE WHEN MONTH(charge_dt) = 7 THEN charge_amt 
		ELSE 0 END) AS July,
        
	SUM(CASE WHEN MONTH(charge_dt) = 8 THEN charge_amt 
		ELSE 0 END) AS August,
        
	SUM(CASE WHEN MONTH(charge_dt) = 9 THEN charge_amt 
		ELSE 0 END) AS September,
        
	SUM(CASE WHEN MONTH(charge_dt) = 10 THEN charge_amt 
		ELSE 0 END) AS October,
        
	SUM(CASE WHEN MONTH(charge_dt) = 11 THEN charge_amt 
		ELSE 0 END) AS November,
        
	SUM(CASE WHEN MONTH(charge_dt) = 12 THEN charge_amt 
		ELSE 0 END) AS December
FROM
	charge;



-- 17. Convert your results to show percentage of total charges for each month.  Round results to 1 decimal place --
SELECT
	ROUND(SUM(CASE WHEN MONTH(charge_dt) = 1 THEN charge_amt 
		ELSE 0 END) / SUM(charge_amt) * 100, 1) AS January,
        
	ROUND(SUM(CASE WHEN MONTH(charge_dt) = 2 THEN charge_amt 
		ELSE 0 END) / SUM(charge_amt) * 100, 1) AS February,
        
	ROUND(SUM(CASE WHEN MONTH(charge_dt) = 3 THEN charge_amt 
		ELSE 0 END) / SUM(charge_amt) * 100, 1) AS March,
        
	ROUND(SUM(CASE WHEN MONTH(charge_dt) = 4 THEN charge_amt 
		ELSE 0 END) / SUM(charge_amt) * 100, 1) AS April,
        
	ROUND(SUM(CASE WHEN MONTH(charge_dt) = 5 THEN charge_amt 
		ELSE 0 END) / SUM(charge_amt) * 100, 1) AS May,
        
	ROUND(SUM(CASE WHEN MONTH(charge_dt) = 6 THEN charge_amt 
		ELSE 0 END) / SUM(charge_amt) * 100, 1) AS June,
        
	ROUND(SUM(CASE WHEN MONTH(charge_dt) = 7 THEN charge_amt 
		ELSE 0 END) / SUM(charge_amt) * 100, 1) AS July,
        
	ROUND(SUM(CASE WHEN MONTH(charge_dt) = 8 THEN charge_amt 
		ELSE 0 END) / SUM(charge_amt) * 100, 1) AS August,
        
	ROUND(SUM(CASE WHEN MONTH(charge_dt) = 9 THEN charge_amt 
		ELSE 0 END) / SUM(charge_amt) * 100, 1) AS September,
        
	ROUND(SUM(CASE WHEN MONTH(charge_dt) = 10 THEN charge_amt 
		ELSE 0 END) / SUM(charge_amt) * 100, 1) AS October,
        
	ROUND(SUM(CASE WHEN MONTH(charge_dt) = 11 THEN charge_amt 
		ELSE 0 END) / SUM(charge_amt) * 100, 1) AS November,
        
	ROUND(SUM(CASE WHEN MONTH(charge_dt) = 12 THEN charge_amt 
		ELSE 0 END) / SUM(charge_amt) * 100, 1) AS December
FROM
	charge;





-- 18. Convert results to show the same information but at the provider_no level and join your results to the provider table using a sub query --
SELECT
	p.*
    , c.January
    , c.February
    , c.March
    , c.April
    , c.May
    , c.June
    , c.July
    , c.August
    , c.September
    , c.October
    , c.November
    , c.December
FROM
	provider p
    LEFT JOIN
		(
        SELECT
			provider_no,
			ROUND(SUM(CASE WHEN MONTH(charge_dt) = 1 THEN charge_amt 
				ELSE 0 END) / SUM(charge_amt) * 100, 1) AS January,
        
			ROUND(SUM(CASE WHEN MONTH(charge_dt) = 2 THEN charge_amt 
				ELSE 0 END) / SUM(charge_amt) * 100, 1) AS February,
				
			ROUND(SUM(CASE WHEN MONTH(charge_dt) = 3 THEN charge_amt 
				ELSE 0 END) / SUM(charge_amt) * 100, 1) AS March,
				
			ROUND(SUM(CASE WHEN MONTH(charge_dt) = 4 THEN charge_amt 
				ELSE 0 END) / SUM(charge_amt) * 100, 1) AS April,
				
			ROUND(SUM(CASE WHEN MONTH(charge_dt) = 5 THEN charge_amt 
				ELSE 0 END) / SUM(charge_amt) * 100, 1) AS May,
				
			ROUND(SUM(CASE WHEN MONTH(charge_dt) = 6 THEN charge_amt 
				ELSE 0 END) / SUM(charge_amt) * 100, 1) AS June,
				
			ROUND(SUM(CASE WHEN MONTH(charge_dt) = 7 THEN charge_amt 
				ELSE 0 END) / SUM(charge_amt) * 100, 1) AS July,
				
			ROUND(SUM(CASE WHEN MONTH(charge_dt) = 8 THEN charge_amt 
				ELSE 0 END) / SUM(charge_amt) * 100, 1) AS August,
				
			ROUND(SUM(CASE WHEN MONTH(charge_dt) = 9 THEN charge_amt 
				ELSE 0 END) / SUM(charge_amt) * 100, 1) AS September,
				
			ROUND(SUM(CASE WHEN MONTH(charge_dt) = 10 THEN charge_amt 
				ELSE 0 END) / SUM(charge_amt) * 100, 1) AS October,
				
			ROUND(SUM(CASE WHEN MONTH(charge_dt) = 11 THEN charge_amt 
				ELSE 0 END) / SUM(charge_amt) * 100, 1) AS November,
				
			ROUND(SUM(CASE WHEN MONTH(charge_dt) = 12 THEN charge_amt 
				ELSE 0 END) / SUM(charge_amt) * 100, 1) AS December
		FROM
			charge
		GROUP BY
			1
		) c
		ON p.provider_no = c.provider_no;



-- 19. Rewrite the same query from problem 18 but leverage common table expressions --
WITH c AS
	(
	SELECT
		provider_no,
		ROUND(SUM(CASE WHEN MONTH(charge_dt) = 1 THEN charge_amt 
			ELSE 0 END) / SUM(charge_amt) * 100, 1) AS "January",
	
		ROUND(SUM(CASE WHEN MONTH(charge_dt) = 2 THEN charge_amt 
			ELSE 0 END) / SUM(charge_amt) * 100, 1) AS "February",
			
		ROUND(SUM(CASE WHEN MONTH(charge_dt) = 3 THEN charge_amt 
			ELSE 0 END) / SUM(charge_amt) * 100, 1) AS "March",
			
		ROUND(SUM(CASE WHEN MONTH(charge_dt) = 4 THEN charge_amt 
			ELSE 0 END) / SUM(charge_amt) * 100, 1) AS "April",
			
		ROUND(SUM(CASE WHEN MONTH(charge_dt) = 5 THEN charge_amt 
			ELSE 0 END) / SUM(charge_amt) * 100, 1) AS "May",
			
		ROUND(SUM(CASE WHEN MONTH(charge_dt) = 6 THEN charge_amt 
			ELSE 0 END) / SUM(charge_amt) * 100, 1) AS "June",
			
		ROUND(SUM(CASE WHEN MONTH(charge_dt) = 7 THEN charge_amt 
			ELSE 0 END) / SUM(charge_amt) * 100, 1) AS "July",
			
		ROUND(SUM(CASE WHEN MONTH(charge_dt) = 8 THEN charge_amt 
			ELSE 0 END) / SUM(charge_amt) * 100, 1) AS "August",
			
		ROUND(SUM(CASE WHEN MONTH(charge_dt) = 9 THEN charge_amt 
			ELSE 0 END) / SUM(charge_amt) * 100, 1) AS "September",
			
		ROUND(SUM(CASE WHEN MONTH(charge_dt) = 10 THEN charge_amt 
			ELSE 0 END) / SUM(charge_amt) * 100, 1) AS "October",
			
		ROUND(SUM(CASE WHEN MONTH(charge_dt) = 11 THEN charge_amt 
			ELSE 0 END) / SUM(charge_amt) * 100, 1) AS "November",
			
		ROUND(SUM(CASE WHEN MONTH(charge_dt) = 12 THEN charge_amt 
			ELSE 0 END) / SUM(charge_amt) * 100, 1) AS "December"
	FROM
		charge
	GROUP BY
		1
	)
SELECT
	p.*
    , c.January
    , c.February
    , c.March
    , c.April
    , c.May
    , c.June
    , c.July
    , c.August
    , c.September
    , c.October
    , c.November
    , c.December
FROM
	provider p
	LEFT JOIN c
		ON p.provider_no = c.provider_no;
		






