-- Revenue per month
SELECT 
    YearMonth,
    SUM(Revenue) AS MonthlyRevenue
FROM sales_powerbi
GROUP BY YearMonth
ORDER BY YearMonth;


-- Top 10 products
SELECT 
    Description,
    SUM(Revenue) AS TotalRevenue
FROM sales_powerbi
GROUP BY Description
ORDER BY TotalRevenue DESC
LIMIT 10;


-- Top 10 Customer
SELECT 
    CustomerID,
    SUM(Revenue) AS TotalRevenue
FROM sales_powerbi
WHERE CustomerID != 0
GROUP BY CustomerID
ORDER BY TotalRevenue DESC
LIMIT 10;


-- Revenue per country
SELECT 
    Country,
    SUM(Revenue) AS CountryRevenue
FROM sales_powerbi
GROUP BY Country
ORDER BY CountryRevenue DESC;

-- Most popular product per country
WITH ranked AS (
    SELECT
        Country,
        Description,
        SUM(Revenue) AS TotalRevenue,
        ROW_NUMBER() OVER (
            PARTITION BY Country
            ORDER BY SUM(Revenue) DESC
        ) AS rn
    FROM sales_powerbi
    GROUP BY Country, Description
)

SELECT
    Country,
    Description,
    TotalRevenue
FROM ranked
WHERE rn = 1
ORDER BY TotalRevenue DESC;

-- Most popular product per customer
WITH ranked AS (
    SELECT
        CustomerID,
        Description,
        SUM(Revenue) AS ProductRevenue,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID
            ORDER BY SUM(Revenue) DESC
        ) AS rn
    FROM sales_powerbi
    WHERE CustomerID != 0
    GROUP BY CustomerID, Description
)

SELECT
    CustomerID,
    Description AS FavoriteProduct,
    ProductRevenue
FROM ranked
WHERE rn = 1
ORDER BY ProductRevenue DESC
LIMIT 10;