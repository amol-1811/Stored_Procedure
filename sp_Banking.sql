CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    AccountHolderName NVARCHAR(255),
    Balance DECIMAL(10, 2)
);

-- Example data insertion (for testing)
INSERT INTO Accounts (AccountID, AccountHolderName, Balance) VALUES
(1, 'Alice Smith', 1000.00),
(2, 'Bob Johnson', 500.00),
(3, 'Charlie Brown', 1500.00);



CREATE PROCEDURE WithdrawAmount
    @AccountID INT,
    @Amount DECIMAL(10, 2)
AS
BEGIN
    BEGIN TRY
        -- Check if account exists
        IF NOT EXISTS (SELECT 1 FROM Accounts WHERE AccountID = @AccountID)
        BEGIN
            THROW 50004, 'Account not found.', 1;
        END

        -- Check if balance is sufficient
        DECLARE @Balance DECIMAL(10, 2);
        SELECT @Balance = Balance FROM Accounts WHERE AccountID = @AccountID;

        IF @Balance < @Amount
        BEGIN
            THROW 50005, 'Insufficient funds.', 1;
        END

        -- Deduct the amount
        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @AccountID;

        PRINT 'Withdrawal successful. Remaining Balance: ' + CAST(@Balance - @Amount AS NVARCHAR(50));
    END TRY
    BEGIN CATCH
        -- Handle errors
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        -- Re-throw the error
        THROW @ErrorSeverity, @ErrorMessage, @ErrorState;
    END CATCH
END;
