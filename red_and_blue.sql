
Task: Find out the number of customers who spent more money on blue goods than on red goods.

SELECT * FROM challenge.Customer
SELECT * FROM challenge.Product
SELECT * FROM challenge.SalesOrderDetail
SELECT * FROM challenge.SalesOrderHeader

WITH 
	Blue as (
	SELECT 
		c.CustomerID,
		SUM(LineTotal) AS total_price
	FROM challenge.Customer c
	INNER JOIN challenge.SalesOrderHeader h ON c.CustomerID = h.CustomerID
	INNER JOIN challenge.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
	INNER JOIN challenge.Product p ON p.ProductID = d.ProductID
	WHERE Color = N'Blue'
	GROUP BY c.CustomerID
),
Red as (
	SELECT 
		c.CustomerID,
		SUM(LineTotal) AS total_price
	FROM challenge.Customer c
	INNER JOIN challenge.SalesOrderHeader h ON c.CustomerID = h.CustomerID
	INNER JOIN challenge.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
	INNER JOIN challenge.Product p ON p.ProductID = d.ProductID
	WHERE Color = N'Red'
	GROUP BY c.CustomerID
)
SELECT
COUNT(b.CustomerID) AS pocet_zakazniku
FROM Blue b
LEFT JOIN Red r ON b.CustomerID = r.CustomerID
WHERE b.total_price > COALESCE (r.total_price, 0)