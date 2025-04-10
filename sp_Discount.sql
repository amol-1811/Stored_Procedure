/*Create an sp where:
A user sends a list of items in their cart.
The API applies best offers/coupons from a stored list (e.g., BOGO, 20% off, Buy 3 get 1).
It returns the final price + savings.*/

--tables required for sp
create table CartItems (
ItemID INT primary key,
UserID INT,
ItemName varchar(100),
Price decimal(10, 2),
Quantity INT
);

insert into CartItems (ItemID, UserID, ItemName, Price, Quantity) values
(1, 1, 'Bag', 100.00, 3), 
(2, 1, 'Pen', 50.00, 2),  
(3, 1, 'Notebook', 30.00, 1),  
(4, 1, 'Scale', 40.00, 4);

create table Offers (
OfferID INT primary key,
OfferType varchar(50),
DiscountValue decimal(10, 2),
MinQuantity INT 
);

insert into Offers (OfferID, OfferType, DiscountValue, MinQuantity) values
(1, 'BOGO', NULL, 2),
(2, 'Percentage', 20, 1),     
(3, 'Buy3Get1', NULL, 3);

create procedure ApplyOffersToCart
@UserID INT
AS
begin
declare @TotalPrice decimal(10, 2) = 0;
declare @TotalSavings decimal(10, 2) = 0;

--calculate total price and savings
select 
@TotalPrice += Price * Quantity,
@TotalSavings += 
CASE 
    when OfferType = 'BOGO' AND Quantity >= 2 then (Price * FLOOR(Quantity / 2))
    when OfferType = 'Percentage' then (Price * Quantity * (DiscountValue / 100))
    when OfferType = 'Buy3Get1' AND Quantity >= 3 then (Price * FLOOR(Quantity / 3))
    else 0
END
FROM CartItems C
LEFT JOIN Offers O ON O.MinQuantity <= C.Quantity
where C.UserID = @UserID;

--calculate final price
SET @TotalPrice = @TotalPrice - @TotalSavings;

--return final price and total savings
select @TotalPrice AS FinalPrice, @TotalSavings AS TotalSavings;
END;

--execute the procedure
EXEC ApplyOffersToCart @UserID = 1;