/*
 * a. How many orders were shipped by Speed Express in total?
 * Answer: 54
 */
SELECT COUNT(*) FROM Orders
JOIN Shippers ON Orders.ShipperID=Shippers.ShipperID
WHERE Shippers.ShipperName = "Speedy Express";

/*
 * b. What is the last name of the employee with the most orders?
 * Answer: Peacock
 */

SELECT Employees.LastName 
FROM Employees
JOIN Orders ON Orders.EmployeeID=Employees.EmployeeID
GROUP BY Orders.EmployeeID
HAVING COUNT(*) = (SELECT MAX(orderCount)
				   FROM (
                   		 SELECT COUNT(*) orderCount
                         FROM Orders
                         GROUP BY Orders.EmployeeID));

/*
 * c. What product was ordered the most by customers in Germany?
 * Answer: Boston Crab Meat
 */

CREATE VIEW QuantityByProductGermany AS
SELECT ProductID, SUM(Quantity) as totalQuantity
FROM OrderDetails
WHERE OrderID in (SELECT OrderID 
                  FROM Orders
                  WHERE CustomerID in (SELECT CustomerID
                                      FROM Customers
                                      WHERE Country='Germany'))
GROUP BY ProductID;

SELECT ProductName 
FROM Products
WHERE ProductID IN ( SELECT ProductID
					 FROM QuantityByProductGermany
                     WHERE totalQuantity = (SELECT MAX(totalQuantity)
                     						FROM QuantityByProductGermany))