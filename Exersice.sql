# NOTES:
# 1. SQL is not case-sensitive; SELECT, select, and SeLeCt are all the same.
#    But it is a best-practice to write are reserved words uppercase (SELECT instead of select)
# 2. Extra line breaks, tabs, and spaces are ignored by SQL
# 3. At the end of each qurey a semicolon (;) is mandatory (unless the last query in the file)
# 4. Comments in SQL start with either '#' or '--' followed by a space
 
 
-- ------------------------- Basic Queries -------------------------
-- 0. USE keyword
USE classicmodels;

-- 1. SELECT and FROM stratements
SELECT *
FROM customers;


-- 2. Column selection
SELECT customerNumber, contactFirstName, contactLastName
FROM customers;


-- 3. Alias
SELECT customerNumber AS `Customer ID`,
	   contactFirstName AS `First Name`,
       contactLastName AS `Last Name`
FROM customers;


-- 4. Arithmatic in SELECT statement
SELECT customerNumber AS `Customer ID`,
	   creditLimit / 10000 AS `Credit Score`
FROM customers;
# Note: Arithmatic Operations (ordered by priority):
# 		() Prioritize
# 		*  Multiplication
# 		/  Division
# 		+  Addition
# 		-  Subtraction 
# 		%  Reminder


-- 5. DISTINCT keyword (to discard repetitions)
SELECT DISTINCT state 
FROM customers;


-- 6. WHERE statement for conditioning and filtering
SELECT * 
FROM customers
WHERE country = 'USA';
# Note: Conditioning options: 
# 		=        for equality
# 		!= or <> for inequality
# 		<        for smaller
# 		> 	     for greater
# 		<=       for smaller or equal to
# 		>=       for greater of equal to


-- 7. Multiple conditioning
SELECT * 
FROM customers 
WHERE (state = 'CA' OR state = 'NY') AND creditLimit > 50000;
# Note: conditions with:
# 		()  -> prioritize
# 		AND -> logical and
# 		OR  -> logical or


-- 8. Date comparison
SELECT *
FROM orders
WHERE orderDate >= '2004-01-01';


-- 9. NOT operation
SELECT *
FROM orders
WHERE NOT status = 'Shipped';
# Note: Execution order of logical conditions (AND, OR, NOT, and parantesis) matters:
# 		() > NOT > AND > OR
# Note: We can do arithmatic in WHERE statement as well 


-- 10. Arithmatic in WHERE statement
SELECT *, creditLimit / 10000 AS creditScore
FROM customers
WHERE (creditLimit / 10000) > 8;


-- 11. IN operator
SELECT *
FROM customers
WHERE state IN ('CA', 'NY', 'Tokyo'); 
# Equivalent query without IN operator:
SELECT *
FROM customers
WHERE state = 'CA' OR state = 'NY' OR state = 'Tokyo';
# Note: Common mistake: WHERE state = 'CA' OR 'NY' OR 'Tokyo'
# Note: We can also use NOT IN


-- 12. NOT IN operator
SELECT *
FROM customers
WHERE state NOT IN ('CA', 'NY', 'Tokyo'); 
# Equivalent query without IN operator
SELECT *
FROM customers
WHERE state <> 'CA' AND state <> 'NY' AND state <> 'Tokyo';


-- 13. BETWEEN operator
SELECT *
FROM customers 
WHERE creditLimit NOT BETWEEN 80000 AND 120000;
# Equivalent query without using BETWEEN operator
SELECT *
FROM customers
WHERE creditLimit >= 80000 AND creditLimit <= 120000;
# Note: We can use NOT BETWEEN as well


-- 14. NOT BETWEEN operator
SELECT *
FROM customers 
WHERE creditLimit NOT BETWEEN 80000 AND 120000;
# Equivalent query without using BETWEEN operator
SELECT *
FROM customers 
WHERE creditLimit < 80000 OR creditLimit > 120000;


-- 15. LIKE operator
SELECT *
FROM customers
WHERE contactFirstName LIKE 'B%';
# Note: Like Options:
# 		% -> any number of characters
# 		_ -> single character


-- 16. LIKE operator 
SELECT *
FROM customers 
WHERE contactFirstName LIKE 'b__';
# Note: You can also use NOT LIKE


-- 17. NOT LIKE operator
SELECT *
FROM customers 
WHERE contactFirstName NOT LIKE '%c%' AND contactLastName NOT LIKE '%c%';
 
 
-- 18. REGEXP operator
SELECT *
FROM customers
WHERE contactLastName REGEXP '^fre|fer';
# Note: REGEXP operators
# 		^  -> begining of a string
# 		$  -> end of a string
# 		|  -> logical or
# 		[] -> any single character lister between bracket
# Note: In this lecture, we don't focus on regular expressions.


-- 19. IS NULL operator
SELECT *
FROM customers
WHERE postalCode IS NULL;


-- 20. IS NOT NULL operator
SELECT *
FROM customers
WHERE addressLine2 IS NOT NULL;


-- 21. ORDER BY statement
SELECT *
FROM customers
WHERE creditLimit > 40000
ORDER BY contactLastName;
# Note: WHERE and ORDER BY statements are optional but 
# 		the order of these statements matters: 
# 		SELECT => FROM => WHERE => ORDER BY


-- 22. ORDER BY statement (multiple column ordering)
SELECT contactFirstName, contactLastName, customerNumber
FROM customers
ORDER BY contactLastName, contactFirstName;
# Equivalent Query:
SELECT contactFirstName, contactLastName, customerNumber
FROM customers
ORDER BY 1, 2; 
# Note: 1 referes to column contactFirstName 
# 		2 referes to column contactLastName


-- 23. DESC option in ORDER BY statement
SELECT contactFirstName
FROM customers
ORDER BY creditLimit DESC;
# Note: if you create new column and set it an ailias,
#  		you can sort the entire table with the new column


-- 24. LIMIT clause
SELECT *
FROM customers
ORDER BY creditLimit DESC
LIMIT 10;


-- 25. LIMIT clause
SELECT *
FROM customers
ORDER BY creditLimit DESC
LIMIT 20, 10;
# Note: New statement ordering:
# 		SELECT => FROM => WHERE => ORDER BY => LIMIT


-- -------------------- Aggrigate Functions Intro --------------------
-- 26. COUNT() functions
SELECT COUNT(*)
FROM customers;

-- 27. MAX() function
SELECT MAX(creditLimit)
FROM customers;

-- 28. MIN() function
SELECT MIN(creditLimit)
FROM customers;

-- 29. AVG() function
SELECT AVG(creditLimit)
FROM customers;

-- 30. SUM() function
SELECT SUM(creditLimit)
FROM customers;

-- ------------------------- Joining Section -------------------------
-- -------------------------   INNER JOIN    -------------------------
-- 31. INNTER JOIN
SELECT orders.orderNumber, orders.status, customers.customerNumber, customers.contactFirstName, customers.contactLastName
FROM customers
INNER JOIN orders ON customers.customerNumber = orders.customerNumber
ORDER BY customerNumber;

# Equivalent Query (Abbriveation):
SELECT o.orderNumber, o.status, c.customerNumber, c.contactFirstName, c.contactLastName
FROM customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
ORDER BY customerNumber;

# Equivalent Query (USING statement):
SELECT o.orderNumber, o.status, c.customerNumber, c.contactFirstName, c.contactLastName
FROM customers c
INNER JOIN orders o USING (customerNumber)
ORDER BY customerNumber;
# Note: USING statemnt only can be used in case both column names are the same
# Note: You also can join tables across different databases, 
# 		you only need to specify the database of each table, such as classicmodels.customers


-- 32. INNER JOIN (with conditioning)
SELECT o.orderNumber, o.status, c.customerNumber, c.contactFirstName, c.contactLastName
FROM customers c
INNER JOIN orders o USING(customerNumber)
WHERE status <> 'Shipped'
ORDER BY customerNumber;
# Note: New statement ordering:
# 		SELECT => FROM => INNER JOIN => WHERE => ORDER BY => LIMIT


-- 33. Self Inner Join
SELECT e.employeeNumber AS employeeNumber, 
	   CONCAT(e.firstName, ' ', e.lastName) AS employeeName, 
       e.jobTitle AS employeeJob,
       m.reportsTo AS managerNumber,
       CONCAT(m.firstName, ' ', m.lastName) AS managerName,
       m.jobTitle AS managerJob
FROM employees e
INNER JOIN employees m ON m.employeeNumber = e.reportsTo AND m.officeCode = e.officeCode;
# Note: In case of self join, you must specify different abbiveation 
#  		for each table, otherwise you'l get error 
#		(here 'e' referes to 'employee' and 'm' referes to 'manager')
# Note: In case of self join, all selected columns must be prefixed by its table
# Note: CONCAT() function can be used to concatenate two columns of type string
#		(you cannot concat strings with +)


-- 34. Joining Mutiple Tables
SELECT od.productCode, p.quantityInStock, p.buyPrice
FROM orders o
INNER JOIN orderdetails od USING (orderNumber)
INNER JOIN products p USING (productCode)
WHERE orderDate BETWEEN '2004-01-01' AND '2004-02-01';


-- 35. Compound Join Conditions
SELECT e.employeeNumber AS employeeNumber, 
	   CONCAT(e.firstName, ' ', e.lastName) AS employeeName, 
       e.jobTitle AS employeeJob,
       m.reportsTo AS managerNumber,
       CONCAT(m.firstName, ' ', m.lastName) AS managerName,
       m.jobTitle AS managerJob
FROM employees e
INNER JOIN employees m ON m.employeeNumber = e.reportsTo AND m.officeCode = e.officeCode;
# Note: Compound join conditions moslty use when we want
#       to join tables with composed column keys


-- 36. Implicit Join
SELECT o.orderNumber, o.status, c.customerNumber, c.contactFirstName, c.contactLastName
FROM customers c, orders o
WHERE o.customerNumber = c.customerNumber
ORDER BY customerNumber;
# Note: This form of joining tables is not recommended, because
# 		compound join conditions and joining mutiple tables
#		in this form, makes the query hard to read.


-- -------------------------   OUTTER JOIN    -------------------------
-- Inner join only gives us customers if and only if they have any order
-- What if we want all the customers, whethere or not they have any order
-- We should use OUTER JOIN
-- There are two types of OUTER JOINs:
--   1) LEFT OUTER JOIN: All records from the left table are returned,
--   	whether or not the join condition is true
-- 	 2) RIGHT OUTER JOIN: All records from the right table are returned,
-- 		whether no not the join condition is true
# NOTE: left table is the one that comes after FROM statement
# 		right table is the one that comes after the JOIN statement


-- 37. OUTER JOIN
SELECT c.customerNumber, c.contactFirstName, c.contactLastName 
FROM customers c
LEFT OUTER JOIN orders o USING (customerNumber)
WHERE orderNumber IS NULL; 
# NOTE: Even though you can convert a left outer join to right outer join,
# 		but it is recommended to always use left outer join, because in case
# 		of multiple join conditions it will become confusing to trace what happend.

# Equivalent Query: Using RIGHT OUTRT JOIN
SELECT c.customerNumber, c.contactFirstName, c.contactLastName
FROM orders o
RIGHT OUTER JOIN customers c USING (customerNumber)
WHERE orderNumber IS NULL;


-- 38. Joining Mutiple Tables (OUTER JOIN)
SELECT *
FROM products p
LEFT OUTER JOIN orderdetails od USING (productCode)
LEFT OUTER JOIN orders o USING (orderNumber)
WHERE o.orderNumber IS NULL;



-- 39. Joining Multiple Tables (OUTER JOIN)
SELECT p.productCode, p.productName
FROM products p
LEFT OUTER JOIN orderdetails od USING (productCode)
LEFT OUTER JOIN orders o USING (orderNumber)
WHERE o.orderDate >= '2003-07-01' AND o.orderDate <= '2003-12-30' AND o.status = 'Shipped';
# NOTE: INNER JOINs and OUTER JOINs can be simuntaliously used in a query.


-- 40. Self Outer Join 
SELECT e.employeeNumber AS employeeID,
	   CONCAT(e.firstname, ' ', e.lastname) AS employeeName,
       e.jobTitle
FROM employees e
LEFT OUTER JOIN employees m ON e.reportsTo = m.employeeNumber
WHERE e.reportsTo IS NULL;
# Note: New statement ordering:
# 		SELECT => FROM => INNER JOIN & OUTER JOIN => WHERE => ORDER BY => LIMIT


-- 41. Natural Join
SELECT e.employeeNumber, 
	   CONCAT(e.firstname, ' ', e.lastname) AS employeeName
FROM employees e
NATURAL JOIN offices o
WHERE city = 'Paris';
# Note: In case of using natural join, it is not required to specify the common 
# 		columns to join based on, it automatically join based on the most common 
# 		column. 
# Note: Even though it has a simpler syntax, it is not recommended.


-- 42. Cross Join
SELECT *
FROM customers c
CROSS JOIN orders o;

# Equivalent Query (Implicit Syntax):
SELECT *
FROM customers c, orders o;



-- 43. Union
SELECT *, 'Active' AS status
FROM orders
WHERE orders.orderDate >= '2005-01-01'
UNION
SELECT *, 'Archived' AS status
FROM orders
WHERE orders.orderDate < '2005-01-01';
# Note: The number of columns of two tables should be the same.
# Note: The columns of the resulting table is the same as the first table






-- 44. Inserting a Row to a Table
INSERT INTO customers
VALUES (1, 
		'amirvahedi18', 
        'Amir', 
        'Vahedi', 
        '09123456789', 
        'abc', 
        NULL, 
        'Tehran', 
        NULL, 
        DEFAULT, 
        'Iran', 
        DEFAULT, 
        DEFAULT);
# Note: For auto increament (AI) columns, we can use either explicit value or DEFAULT
# 		For nullable columns, we can use NULL, DEFAULT, or explicit values
# 		For detault value columns, we an use either explicit value or DEFAULT

# Equivaient Query
INSERT INTO customers (customerNumber, customerName, contactFirstName, contactLastName, phone, addressLine1, city, country) 
VALUES (2, 'amirvahedi', 'AMIR', 'VAHEDI', '091234656789', 'abc', 'Tehran', 'IRAN');


# To Insert Multiple Values:
INSERT INTO customers (customerNumber, customerName, contactFirstName, contactLastName, phone, addressLine1, city, country) 
VALUES (3, 'amirvahedi', 'AMIR', 'VAHEDI', '091234656789', 'abc', 'Tehran', 'IRAN'),
	   (4, 'john', 'A', 'B', '091234656789', 'abc', 'Tehran', 'IRAN'),
       (5, 'kim', 'C', 'D', '091234656789', 'abc', 'Tehran', 'IRAN');



-- 45. Inserting Hierarical Rows
INSERT INTO orders (orderNumber, orderDate, requiredDate, status, customerNumber)
VALUES (12, '2023-04-18', '2023-04-23', 'shipped', 1);

INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES (12, 'S10_1678', 2, 200, 3);


-- 46. Creating a copy of a table
CREATE TABLE orders_archived AS 
SELECT * FROM orders;
# Note: In the copied table, we don't have a primay key and it is not auto incrimental
# Note: The second line of the above query is a sub-query, as a part of another query.


-- 47. Deleting rows and adding selected rows
DELETE FROM orders_archived; # require safe mode to be disabled

INSERT INTO orders_archived
	(SELECT *
	 FROM orders
	 WHERE orderDate < '2004-01-01');


-- 48. Creating table + Subquery
DROP TABLE IF EXISTS customer_payment;
CREATE TABLE customer_payment AS 
SELECT p.checkNumber, c.customerNumber, c.contactFirstName, c.contactLastName
FROM customers c
INNER JOIN payments p USING (customerNumber)
WHERE p.paymentDate < '2004-01-01';




-- 49. Update single row
UPDATE payments
SET amount = amount * 1.1
WHERE checkNumber = 'HQ336336';


-- 50. Update Multiple rows
UPDATE payments 
SET amount = amount * 1.1
WHERE checkNumber IN ('JM555205', 'GG31455', 'FD317790', 'NT141748', 'ID10962', 'HR182688');

-- 51. Update multiple rows
UPDATE orders 
SET requiredDate = DATE_ADD(requiredDate, INTERVAL 1 DAY)
WHERE status = 'Cancelled';

SELECT * FROM customers;

-- 52. Update table + Subqueries
UPDATE customers
SET creditLimit = creditLimit * 1.2
WHERE customerNumber = ( 
	SELECT customerNumber
	FROM customers
	INNER JOIN orders o USING (customerNumber)
	ORDER BY o.orderDate
	LIMIT 1); -- >> Error

# Correct Query
UPDATE customers
SET creditLimit = creditLimit * 1.2
WHERE customerNumber = (
	SELECT customerNumber FROM (
		SELECT customerNumber 
        FROM customers 
        INNER JOIN orders o 
        USING (customerNumber) 
        ORDER BY o.orderDate 
        LIMIT 1
    ) AS t
);
# Note: If the subquery returns more than one value, you should use IN operator instead of =


SELECT creditLimit 
FROM customers 
WHERE customerNumber = (
	SELECT customerNumber 
    FROM customers 
    INNER JOIN orders o 
    USING (customerNumber) 
    ORDER BY o.orderDate LIMIT 1
);


-- 53. Upate Multiple Rows + Subqueries
UPDATE customers
SET creditLimit = creditLimit * 0.85
WHERE customerNumber IN (
	SELECT customerNumber 
    FROM (
		SELECT DISTINCT c.customerNumber 
		FROM customers c
		INNER JOIN orders o USING (customerNumber)
		WHERE o.status = 'Cancelled'
    ) AS t
);


SELECT customerNumber, creditLimit
FROM customers
WHERE customerNumber IN (
	SELECT DISTINCT c.customerNumber 
	FROM customers c
	INNER JOIN orders o USING (customerNumber)
	WHERE o.status = 'Cancelled'
);


-- 54. Aggrigate Functions + GROUP BY clause
SELECT orderNumber, customerNumber, SUM(quantityOrdered * priceEach) AS totalPrice 
FROM orders o
INNER JOIN orderdetails od USING (orderNumber)
GROUP BY orderNumber, customerNumber; 
# Note: Aggrigate funtions should be groupped by selected columns except the one 
# 		that it is aggregated, here both orderNumber and customerNumber columns.
# Note: New statement ordering:
# 		SELECT => FROM => INNER JOIN & OUTER JOIN => WHERE => GROUP BY => ORDER BY => LIMIT
# Note: If we want to apply any condition on the groupped columns, we cannot use WHERE caluse,
# 		because the grouping is not happend yet, So we have to use HAVING cluse after the 
# 		GROUP BY clause.




-- 55. Conditional Aggregate Function + GROUP BY clause
SELECT customerNumber, 
	   CONCAT(contactFirstName, contactLastName) AS fullName, 
       SUM(amount) AS totalPayments
FROM customers
INNER JOIN payments USING (customerNumber)
WHERE country = 'USA'
GROUP BY customerNumber, fullName
HAVING totalPayments > 100000;
# Note: With the WHERE clause we can filter data before rows are grouped,
# 		With the HAVING clause we can filter data after rows are grouped.
# Note: Columns that come after the HAVING clause should be among SELECTed columns, 
# 		but any column can be used with WHERE clause.
# Note: New statement ordering:
# 		SELECT => FROM => JOIN => WHERE => GROUP BY => HAVING => ORDER BY => LIMIT



-- 56. WITH ROLLUP
SELECT country, city, SUM(amount) AS totalSale
FROM customers c
INNER JOIN payments p USING (customerNumber)
GROUP BY country, city WITH ROLLUP;
# Note: In case of using ROLLUP operator, we cannot use a column ailias in a GROUP BY clause.
# Note: USE ROLLUP is MySQL-exlusive



-- 57. Nested Subqueries
SELECT customerNumber, 
	   CONCAT(contactFirstName, ' ', contactLastName) AS customerName,
       SUM(amount) AS totalPaid
FROM customers
INNER JOIN payments USING(customerNumber)
GROUP BY customerNumber, customerName
HAVING totalPaid > (
	SELECT AVG(totalPaid)
	FROM (
		SELECT SUM(amount) AS totalPaid
		FROM customers 
		INNER JOIN payments USING(customerNumber)
		GROUP BY customerNumber, customerName
	) AS t
);



-- 58. Using IN operator in subqueries
SELECT *
FROM products
WHERE productCode NOT IN (
	SELECT DISTINCT productCode
	FROM products p
	INNER JOIN orderdetails od USING (productCode)
);




-- 59. 
SELECT productCode, productName, SUM(quantityOrdered) AS quantitySold
FROM products p
INNER JOIN orderdetails od USING (productCode)
GROUP BY productCode, productName
ORDER BY quantitySold DESC;



-- 60. 
SELECT productCode, productName, SUM(quantityOrdered * priceEach) AS amountSold
FROM products p
INNER JOIN orderdetails od USING (productCode)
GROUP BY productCode, productName
ORDER BY amountSold DESC;




-- 61. 
SELECT customerNumber, CONCAT(contactFirstName, ' ', contactLastName) AS customerName
FROM customers
WHERE customerNumber IN (
	SELECT customerNumber
    FROM orders
    WHERE orderNumber IN (
		SELECT orderNumber
        FROM orderdetails
        WHERE productCode = 'S12_4473'
    )
)
ORDER BY customerNumber;



SELECT DISTINCT customerNumber, CONCAT(contactFirstName, ' ', contactLastName) AS customerName
FROM customers
INNER JOIN orders USING (customerNumber)
INNER JOIN orderdetails USING (orderNumber)
WHERE productCode = 'S12_4473'
ORDER BY customerNumber;





-- 62. ALL Keyword
SELECT *
FROM customers
WHERE creditLimit > (
	SELECT MAX(creditLimit)
    FROM customers
    WHERE country = 'USA'
);

# Equivalent Query 
SELECT *
FROM customers
WHERE creditLimit > ALL (
	SELECT creditLimit
    FROM customers
    WHERE country = 'USA'
);


-- 63. ANY Keyword
SELECT *
FROM customers
WHERE creditLimit > (
	SELECT MIN(creditLimit)
    FROM customers
    WHERE country = 'USA'
);

# Equivalent Query 
SELECT *
FROM customers
WHERE creditLimit > ANY (
	SELECT creditLimit
    FROM customers
    WHERE country = 'USA'
);


-- 64. 
SELECT customerNumber, CONCAT(contactFirstName, ' ',  contactLastName) AS customerName
FROM customers
WHERE customerNumber IN (
	SELECT customerNumber
	FROM payments
	GROUP BY customerNumber
	HAVING COUNT(*) >= 4
);


# Equivalent Query
SELECT customerNumber, CONCAT(contactFirstName, ' ', contactLastName) AS customerName
FROM customers
WHERE customerNumber = ANY (
	SELECT customerNumber
	FROM payments
	GROUP BY customerNumber
	HAVING COUNT(*) >= 4
);

# Equivalent Query
SELECT customerNumber, CONCAT(contactFirstName, ' ', contactLastName) AS customerName
FROM customers
INNER JOIN payments USING(customerNumber)
GROUP BY customerNumber
HAVING COUNT(*) >= 4;



-- 65. 
SELECT *
FROM products
WHERE productCode IN (
	SELECT productCode
	FROM orderdetails
	GROUP BY productCode
	HAVING COUNT(*) > 27
);

# Equivalent Query:
SELECT *
FROM products p 
WHERE productCode = ANY (
	SELECT productCode
	FROM orderdetails
	GROUP BY productCode
	HAVING COUNT(*) > 27
);


-- 66. EXISTS Keyword
SELECT *
FROM orders
WHERE customerNumber IN (
	SELECT customerNumber
    FROM customers
    INNER JOIN orders USING(customerNumber)
    WHERE country = 'USA'
);

# Note: If the result of subquery is too huge, 
# 		it is more efficient to use EXISTS keyword as follows:
# Equivalent Query:
SELECT *
FROM orders o
WHERE EXISTS (
	SELECT customerNumber
	FROM customers
	INNER JOIN orders USING (customerNumber)
	WHERE country = 'USA' AND o.customerNumber = customerNumber
);


-- 67. Subquery in the SELECT statement
SELECT *, 
		creditLimit - (
			SELECT AVG(creditLimit)
            FROM customers
            WHERE country = 'USA'
        ) AS differenceCreditLimit
FROM customers;


-- 68. Subquery in the FROM statement
SELECT *
FROM (
	SELECT customerNumber, 
		CONCAT(contactFirstName, contactLastName) AS customerName, 
		SUM(amount) AS totalPayment
	FROM customers
	INNER JOIN payments USING (customerNumber)
	GROUP BY customerNumber, customerName
) AS subTable
WHERE totalPayment < (
	SELECT AVG(totalPayment)
    FROM (
		SELECT SUM(amount) AS totalPayment
		FROM customers
		INNER JOIN payments USING (customerNumber)
		GROUP BY customerNumber
        ) AS subTable
);

# Equivalent (Simpler) Query:
SELECT customerNumber, SUM(amount) AS totalPayment
FROM customers 
INNER JOIN payments USING (customerNumber)
GROUP BY customerNumber
HAVING totalPayment < (
	SELECT AVG(totalPayment)
    FROM (
		SELECT SUM(amount) AS totalPayment
		FROM customers 
		INNER JOIN payments USING(customerNumber)
		GROUP BY customerNumber
        ) AS subTable
);

-- 69. Numeric Function: ROUND()
SELECT customerNumber, 
	   ROUND(creditLimit / (
			SELECT MAX(creditLimit) - MIN(creditLimit)
			FROM customers), 2)
FROM customers;


-- 70. Numeric Function: TRUNCATE()
SELECT customerNumber, 
	   TRUNCATE(creditLimit / (
			SELECT MAX(creditLimit) - MIN(creditLimit)
			FROM customers), 2)
FROM customers;
# Note: Other Numeric Functions:
# 		CEILING(column_name), FLOOR(column_name), ABS(column_name), ROND()


-- 71. String Functions: LENGTH():
SELECT customerNumber, LENGTH(addressLine1)
FROM customers;


-- 72, String Function: UPPER(), LOWER()
SELECT customerNumber, 
	   LOWER(contactFirstName) AS fristName, 
       UPPER(contactLastName) AS lastName
FROM customers;
# Note: Other String Functions:
# 		LTRIM(column_name), RTRIM(column_name), TRIM(column_name)
#		LEFT(column_name, length), RIGHT(column_name, length)
# 		SUBSTrinG(column_name, start_index, end_index)
# 		LOCATE(search_string, column)
# 		REPLACE(column, string_to_be_replaced, replacement_string)
# 		CONCAT(column1, column2)



-- 73. Date Functions:
SELECT NOW();
SELECT CURDATE(); # current date
SELECT CURTIME(); # current time
SELECT YEAR(NOW()); # current year
SELECT MONTH(NOW()); # current month in year
SELECT WEEK(NOW()); # current week in year
SELECT DAY(NOW()); # current day in month
SELECT HOUR(NOW()); # current hour in day
SELECT MINUTE(NOW()); # current minute in HOUR
SELECT SECOND(NOW()); # curren second in minute
SELECT DAYNAME(NOW()); # name of the current day
SELECT MONTHNAME(NOW()); # name of the current month
SELECT EXTRACT(YEAR FROM NOW());
SELECT DATE_FORMAT(NOW(), '%M %D %Y');
SELECT DATE_FORMAT(NOW(), '%m %d %y');
SELECT TIME_FORMAT(NOW(), '%H:%i %p');
SELECT TIME_FORMAT(NOW(), '%h:%i %p');
SELECT DATE_ADD(NOW(), INTERVAL 1 DAY); # tomarrow
SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR); # next year
SELECT DATE_SUB(NOW(), INTERVAL 1 DAY); # yestarday
SELECT DATE_ADD(NOW(), INTERVAL -1 DAY); # yesterday
SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR); # previous year
SELECT DATEDIFF(CURDATE(), '2004-01-01'); # different in days
SELECT TIME_TO_SEC(NOW());


-- 75. IFNULL()
SELECT customerNumber, 
	   addressLine1, 
       IFNULL(addressLine2, 'NotAssigned') AS addressLine2
FROM customers;


-- 76. COALESCE()
SELECT customerNumber, COALESCE(addressLine2, state, 'NotAssigned')
FROM customers;


-- 77. IF function
SELECT *, IF (orderDate < '2004-01-01', 'Archived', 'Active') AS dateStatus
FROM orders; 


-- 78. IF function
SELECT customerNumber, 
	   IF (COUNT(orderNumber) > 4, 'Vafadar', 'Mamoli') AS vafadari 
FROM customers
INNER JOIN orders USING(customerNumber)
GROUP BY customerNumber;



-- 79. CASE Operator
SELECT o.customerNumber, 
	   CASE 
			WHEN COUNT(orderNumber) > 10 THEN 'very_vafadar'
            WHEN COUNT(orderNumber) > 4 THEN 'vafadar'
            ELSE 'mamoli'
		END AS vafadari
FROM customers c
INNER JOIN orders o USING(customerNumber)
GROUP BY o.customerNumber;


-- 80. VIEWS
CREATE VIEW american_customers AS (
	SELECT *
	FROM customers
	WHERE country = 'USA'
);

SELECT *
FROM american_customers;


# NOTE: After creating a view you can use it like a table.
# NOTE: VIEWs are usually used like a variable, 
#		but they don't store any data, they refer to the 
# 		original table, any chnage in on a view will be 
# 		applied on the original table.
# NOTE: General query to create a view:
# 		CREATE VIEW <view_name> AS (<subquery>)	
# NOTE: Benefits of Views:
# 		1) Simplifying Queries (act as abstraction layer)
#		2) Reduce the impact of changes
# 		3) Restrict access to data
# 		4) More secure (than apply queries on the table itself)
# But don't apply views blindly in every case.

-- 81. DROP VIEW
DROP VIEW american_customers;


# NOTE: General query to drop a view:
#		DROP VIEW <view_name>




-- 82. VIEW
CREATE VIEW special_customers AS (
	SELECT *
	FROM customers c
	INNER JOIN orders o USING(customerNumber)
	INNER JOIN orderdetails od USING (orderNumber)
	WHERE quantityOrdered > 30 AND productCode = 'S10_4962'
);


-- 83. CREATE OR REPLACE VIEW 
CREATE OR REPLACE VIEW special_customers AS (
	SELECT * 
    FROM customers
    INNER JOIN orders USING(customerNumber)
    INNER JOIN orderdetails USING(orderNumber)
    WHERE quantityOrdered > 20 AND productCode = 'S12_3380'
);




-- 84. Updateable Views
# A view should NOT contain any of the following statements to be 
# an updateable view:
# DISTINCT
# Aggrigate Functions
# GROUP BY / HAVING
# UNION



-- 85. Stored Procedure
# In your application you should not put your application code in the application code.
# Instead, you should take SQL code out of your application code and store it in a database 
# it blongs to. Store it in a stored procedure or function.

# Stored Procedure: A database object that contains a block of SQL code. We call this 
# procedure in our application code to get/store data.

# Benefits of Using Stored Procedure:
# 1. Store and organize SQL 
# 2. Faster Execution
# 3. Data Security (removing drict access to all tables)

# Creating a Stored Procedure:
DELIMITER $$
CREATE PROCEDURE get_customers()
BEGIN 
	SELECT *
    FROM customers;
END $$
DELIMITER ;

CALL get_customers();




-- 86. Dropping a Stored Procedure
DROP PROCEDURE get_customers;

# Note: Better approach to drop a stored procedure is as follow, without giving any error:
DROP PROCEDURE IF EXISTS get_customers;

# Note: To update a stored procedure:
DROP PROCEDURE IF EXISTS get_customers;
DELIMITER $$
CREATE PROCEDURE get_customers()
BEGIN
	SELECT *
    FROM customers;
END $$
DELIMITER ;



-- 87. Parameterized Stored Procedure:
DROP PROCEDURE IF EXISTS get_customers_by_country;
DELIMITER $$
CREATE PROCEDURE get_customers_by_country(country CHAR(15))
BEGIN
	SELECT * 
    FROM customers c
    WHERE c.country = country;
END $$
DELIMITER ;

CALL get_customers_by_country('USA');



-- 88. Default Value for Parameters
DROP PROCEDURE IF EXISTS get_customers_by_country;
DELIMITER $$
CREATE PROCEDURE get_customers_by_country(country CHAR(15))
BEGIN 
	IF country IS NULL THEN
		SELECT *
        FROM customers;
	ELSE 
		SELECT *
        FROM customers c
        WHERE c.country = country;
	END IF;
END $$
DELIMITER ;

CALL get_customers_by_country(NULL);
CALL get_customers_by_country('Japan');

# Equivalent Query:
DROP PROCEDURE IF EXISTS get_customers_by_country;
DELIMITER $$
CREATE PROCEDURE get_customers_by_country(country CHAR(15))
BEGIN 
	SELECT *
    FROM customers c
    WHERE c.country = IFNULL(country, c.country);
END $$
DELIMITER ;

CALL get_customers_by_country(NULL);
CALL get_customers_by_country('Japan');


-- 89. Default For Parameters
DROP PROCEDURE IF EXISTS get_customers_by_country;
DELIMITER $$
CREATE PROCEDURE get_customers_by_country(country CHAR(15))
BEGIN 
	IF country IS NULL THEN 
		SET country = 'USA';
	END IF;
    SELECT *
    FROM customers c
    WHERE c.country = country;
END $$
DELIMITER ;

CALL get_customers_by_country(NULL);
CALL get_customers_by_country('Japan');




-- 90. Stored Procedure
DROP PROCEDURE IF EXISTS get_orders;
DELIMITER $$
CREATE PROCEDURE get_orders(customerNumber INT, status_ VARCHAR(15))
BEGIN
	SELECT *
    FROM orders o 
    WHERE o.customerNumber = IFNULL(customerNumber, o.customerNumber) AND 
		  o.status = IFNULL(status_, o.status);
END $$

CALL get_orders(NULL, NULL);
CALL get_orders(177, NULL);
CALL get_orders(NULL, 'Shipped');
CALL get_orders(177, 'Shipped');















