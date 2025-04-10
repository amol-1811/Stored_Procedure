SELECT product_name, list_price FROM production.products
ORDER BY product_name;

--create stored procedure
ALTER PROC uspProductList
AS
BEGIN 
SELECT product_name, list_price FROM production.products
ORDER BY product_name;
END;

--execute a stored procedure
EXEC uspProductList

--creating sp with one parameter
CREATE PROCEDURE uspFindProducts
AS
BEGIN
SELECT product_name, list_price FROM production.products
ORDER BY list_price;
END;

ALTER PROCEDURE uspFindProducts(@min_list_price AS DECIMAL)
AS
BEGIN
SELECT product_name, list_price FROM production.products
WHERE list_price >= @min_list_price
ORDER BY list_price;
END;

--Creating a sp with multiple parameters
ALTER PROCEDURE uspFindProducts(
@min_list_price AS DECIMAL
,@max_list_price AS DECIMAL
)
AS
BEGIN
SELECT product_name, list_price FROM production.products
WHERE list_price >= @min_list_price AND list_price <= @max_list_price
ORDER BY list_price;
END;


--BEGIN...END statement
BEGIN
SELECT product_id, product_name FROM production.products
WHERE list_price > 100000;
IF @@ROWCOUNT = 0
PRINT 'No product with price greater than 100000 found';
END

--IF statement
BEGIN
DECLARE @sales INT; 
SELECT @sales = SUM(list_price * quantity) FROM sales.order_items i
INNER JOIN sales.orders o ON o.order_id = i.order_id
WHERE YEAR(order_date) = 2018;
SELECT @sales;
IF @sales > 1000000
BEGIN
PRINT 'Great! The sales amount in 2018 is greater than 1,000,000';
END
END

--IF ELSE statement
BEGIN
DECLARE @sales INT;

SELECT 
@sales = SUM(list_price * quantity)
FROM
sales.order_items i
INNER JOIN sales.orders o ON o.order_id = i.order_id
WHERE
YEAR(order_date) = 2017;

SELECT @sales;
IF @sales > 10000000
BEGIN
PRINT 'Great! The sales amount in 2018 is greater than 10,000,000';
END
ELSE
BEGIN
PRINT 'Sales amount in 2017 did not reach 10,000,000';
END
END

--WHILE statement
DECLARE @counter INT = 1;
WHILE @counter <= 5
BEGIN
PRINT @counter;
SET @counter = @counter + 1;
END

--BREAK statement
DECLARE @counter INT = 0;
WHILE @counter <= 5
BEGIN
SET @counter = @counter + 1;
IF @counter = 4
    BREAK;
PRINT @counter;
END

--CONTINUE statement
DECLARE @counter INT = 0;
WHILE @counter < 5
BEGIN
SET @counter = @counter + 1;
IF @counter = 3
    CONTINUE;	
PRINT @counter;
END

--TRY CATCH block
CREATE PROC usp_divide(
@a decimal,
@b decimal,
@c decimal output
) AS
BEGIN
BEGIN TRY
    SET @c = @a / @b;
END TRY
BEGIN CATCH
    SELECT  
    ERROR_NUMBER() AS ErrorNumber,  
    ERROR_SEVERITY() AS ErrorSeverity, 
    ERROR_STATE() AS ErrorState,  
    ERROR_PROCEDURE() AS ErrorProcedure,  
    ERROR_LINE() AS ErrorLine,  
    ERROR_MESSAGE() AS ErrorMessage;  
END CATCH
END;
GO

DECLARE @r decimal;
EXEC usp_divide 10, 2, @r output;
PRINT @r;

DECLARE @r2 decimal;
EXEC usp_divide 10, 0, @r2 output;
PRINT @r2;
