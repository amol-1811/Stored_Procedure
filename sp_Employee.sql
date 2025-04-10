CREATE TABLE Employee(
	EmpID INT,
	Name VARCHAR(50),
	DeptID INT,
	Salary DECIMAL(10,2),
	JoinYear INT
)

INSERT INTO Employee (EmpID, Name, DeptID, Salary, JoinYear) VALUES
(1001, 'Amol Gosavi', 1, 45000, 2002),
(1002, 'Asmita Girhepunje', 2, 55000, 2000),
(1003, 'Puja Borse', 1, 35000, 2005),
(1004, 'Disha Kanmble', 4, 32000, 2004),
(1005, 'NP Narsimha', 2, 40000, 2002),
(1006, 'Rishikesh Kharade', 3, 50000, 2001);

--create stored procedure
ALTER PROCEDURE spDepartList
AS
BEGIN
SELECT * FROM Employee;
END

--execute stored procedure
spDepartList
Execute spDepartList
EXEC spDepartList

--alter stored procedure
ALTER PROC spDepartList
(
@EmpID INT,
@Name VARCHAR(50),
@DeptID INT,
@Salary DECIMAL(10,2),
@JoinYear INT
)
AS
BEGIN
INSERT INTO Employee(EmpID,Name,DeptID,Salary,JoinYear)values(@EmpID,@Name,@DeptID,@Salary,@JoinYear);
SELECT * FROM Employee;
END;

EXEC spDepartList 1007, 'abc', 5, 60000, 2000;
EXEC spDepartList 1008, 'xyz', 4, 85000, 2001;

--update stored procedure
CREATE PROC spUpdateEmp
(
@EmpID INT,
@Name VARCHAR(50),
@DeptID INT,
@Salary DECIMAL(10,2),
@JoinYear INT
)
AS
BEGIN
UPDATE Employee SET Name=@Name, DeptID=@DeptID, Salary=@Salary, JoinYear=@JoinYear WHERE EmpID=@EmpID;
END;

EXEC spUpdateEmp 1001, 'Amol Gosavi', 1, 45000, 2000;

--delete from stored procedure
CREATE  PROC spDeleteEmp
(
@EmpID INT
)
AS
BEGIN
DELETE FROM Employee WHERE EmpID=@EmpID;
END;

EXEC spDeleteEmp 1008;