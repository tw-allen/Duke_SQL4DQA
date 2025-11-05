-- ------------------------------------------------------------------------------------------- --
-- ---------------------------------------  Week 3 Lab  -------------------------------------- --
-- ------------------------------------------------------------------------------------------- --

-- Instructions --

-- Use the tpch relational dataset to answer the following questions. Write your code in this
-- file after each corresponding question and include a comment with the answer to the question
-- if applicable.  Code should use syntax best practices.  Submit code at end of lab session.



-- About the tpch database --

-- The tpch relational dataset contains data on 1.5 million orders for 'parts'.  The orders table 
-- contains data on each order.  The line item table contains data on the specific parts included
-- in each order.  The customer, nation, part, partsupp, region, and supplier tables all contain
-- additional data that can be related back to the orders and line items. 







-- 1. Return all parts with a below average retail price --
SELECT
	*
FROM
	part
WHERE
	p_retailprice <
		(
		SELECT
			AVG(p_retailprice)
		FROM
			part
		)
;




-- 2. Return all customers who have an account balance smaller than the smallest order with status of 'P' in the data base --
SELECT
	*
FROM
	customer
WHERE
	c_acctbal <
		(
        SELECT
			MIN(o_totalprice)
		FROM
			orders
		WHERE
			o_orderstatus = "P"
		)
;
			






-- 3. Return all columns from the customers table as well as a column that categorizes account balances into small, medium, large --
-- and extra large balances.  Extra large balances are considered to be over $8k, large balances are considered to be larger than $6k --
-- and less than or equal to $8k, medium balances are considered to be larger than $3k and less than or equal to $6k, and small orders are --
-- considered to be $3k or less. --
SELECT
	*
    , CASE
		WHEN c_acctbal > 8000
			THEN "extra large"
		WHEN c_acctbal > 6000
			THEN "large"
		WHEN c_acctbal > 3000
			THEN "medium"
		ELSE "small"
	END AS "Account Balance Size"
FROM
	customer
;




-- 4. Using a sub query return a list of all nations who have a customer with a '988' area code and an account balance of at least $9,500  --
SELECT
	*
FROM
	nation
WHERE
	n_nationkey IN
		(
        SELECT
			c_nationkey
		FROM
			customer
		WHERE
			c_phone LIKE "988%"
            AND c_acctbal >= 9500
		)
;
    
			
		





-- 5. Which customer market segments have a higher total account balance than the automobile and building segments? --
SELECT
	c_mktsegment
    , SUM(c_acctbal) AS "Total Account Balance"
FROM
	customer
GROUP BY
	1
HAVING
	SUM(c_acctbal) >
		(
        SELECT
			SUM(c_acctbal)
		FROM
			customer
		WHERE
			c_mktsegment = "AUTOMOBILE"
		)
	AND SUM(c_acctbal) >
		(
        SELECT
			SUM(c_acctbal)
		FROM
			customer
		WHERE
			c_mktsegment = "BUILDING"
		)
;





-- 6. Write a query that show percent of total orders for each order priority (results should be on one row) --
SELECT
	SUM(
		CASE
			WHEN o_orderpriority = "1-URGENT"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 1 Percent"
	, SUM(
		CASE
			WHEN o_orderpriority = "2-HIGH"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 2 Percent"
	, SUM(
		CASE
			WHEN o_orderpriority = "3-MEDIUM"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 3 Percent"
	, SUM(
		CASE
			WHEN o_orderpriority = "4-NOT SPECIFIED"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 4 Percent"
	, SUM(
		CASE
			WHEN o_orderpriority = "5-LOW"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 5 Percent"
FROM
	orders;
	





-- 7. Write a query that show percent of total order value for each order priority (results should be on one row) --
SELECT
	SUM(
		CASE
			WHEN o_orderpriority = "1-URGENT"
				THEN o_totalprice
                ELSE 0
			END
		) / SUM(o_totalprice) * 100 AS "Priority 1 Percent"
	, SUM(
		CASE
			WHEN o_orderpriority = "2-HIGH"
				THEN o_totalprice
                ELSE 0
			END
		) / SUM(o_totalprice) * 100 AS "Priority 2 Percent"
	, SUM(
		CASE
			WHEN o_orderpriority = "3-MEDIUM"
				THEN o_totalprice
                ELSE 0
			END
		) / SUM(o_totalprice) * 100 AS "Priority 3 Percent"
	, SUM(
		CASE
			WHEN o_orderpriority = "4-NOT SPECIFIED"
				THEN o_totalprice
                ELSE 0
			END
		) / SUM(o_totalprice) * 100 AS "Priority 4 Percent"
	, SUM(
		CASE
			WHEN o_orderpriority = "5-LOW"
				THEN o_totalprice
                ELSE 0
			END
		) / SUM(o_totalprice) * 100 AS "Priority 5 Percent"
FROM
	orders;






-- 8. Rewrite your query from #6 so that the data is now at the customer number level  --
SELECT
	o_custkey
	,SUM(
		CASE
			WHEN o_orderpriority = "1-URGENT"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 1 Percent"
	, SUM(
		CASE
			WHEN o_orderpriority = "2-HIGH"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 2 Percent"
	, SUM(
		CASE
			WHEN o_orderpriority = "3-MEDIUM"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 3 Percent"
	, SUM(
		CASE
			WHEN o_orderpriority = "4-NOT SPECIFIED"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 4 Percent"
	, SUM(
		CASE
			WHEN o_orderpriority = "5-LOW"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 5 Percent"
FROM
	orders
GROUP BY 
	o_custkey;





-- 9. Join your results from #8 to the customer table (all customers should be in result set) --
SELECT
	c.*
	,SUM(
		CASE
			WHEN o.o_orderpriority = "1-URGENT"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 1 Percent"
	, SUM(
		CASE
			WHEN o.o_orderpriority = "2-HIGH"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 2 Percent"
	, SUM(
		CASE
			WHEN o.o_orderpriority = "3-MEDIUM"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 3 Percent"
	, SUM(
		CASE
			WHEN o.o_orderpriority = "4-NOT SPECIFIED"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 4 Percent"
	, SUM(
		CASE
			WHEN o.o_orderpriority = "5-LOW"
				THEN 1
                ELSE 0
			END
		) / COUNT(*) * 100 AS "Priority 5 Percent"
FROM
	customer c
    LEFT JOIN orders o
		ON o.o_custkey = c.c_custkey
GROUP BY 
	c.c_custkey;





-- 10. Rewrite the query from the previous problem but this time use a common table expression --
WITH priority_percentages AS
	(
    SELECT
		o_custkey
		, SUM(
			CASE
				WHEN o_orderpriority = "1-URGENT"
					THEN 1
					ELSE 0
				END
		) / COUNT(*) * 100 AS pty_1_pct
		, SUM(
			CASE
				WHEN o_orderpriority = "2-HIGH"
					THEN 1
					ELSE 0
				END
		) / COUNT(*) * 100 AS pty_2_pct
		, SUM(
			CASE
				WHEN o_orderpriority = "3-MEDIUM"
					THEN 1
					ELSE 0
				END
		) / COUNT(*) * 100 AS pty_3_pct
		, SUM(
			CASE
				WHEN o_orderpriority = "4-NOT SPECIFIED"
					THEN 1
					ELSE 0
				END
		) / COUNT(*) * 100 AS pty_4_pct
		, SUM(
			CASE
				WHEN o_orderpriority = "5-LOW"
					THEN 1
					ELSE 0
				END
		) / COUNT(*) * 100 AS pty_5_pct
	FROM
		orders
	GROUP BY
		o_custkey
)
SELECT
	c.*
    , p.pty_1_pct
    , p.pty_2_pct
    , p.pty_3_pct
    , p.pty_4_pct
    , p.pty_5_pct
FROM
	customer c
    LEFT JOIN priority_percentages p
		ON p.o_custkey = c.c_custkey;
        
	






	
	





