CREATE DATABASE TaskDB;

USE TaskDB;



CREATE TABLE Bookss (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(100),
    AuthorID INT,
    PublisherID INT,
    PublicationYear INT
);

CREATE TABLE Authors (
    AuthorID INT IDENTITY(1,1) PRIMARY KEY,
    AuthorName VARCHAR(100)
);

CREATE TABLE Publishers (
    PublisherID INT IDENTITY(1,1) PRIMARY KEY,
    PublisherName VARCHAR(100)
);


CREATE TABLE Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    BookID INT FOREIGN KEY REFERENCES Bookss(BookID) 
	ON DELETE CASCADE 
	ON UPDATE CASCADE,
    SaleDate DATE,
    SaleAmount DECIMAL(10,2)
);


INSERT INTO Authors (AuthorName) VALUES
('J.K. Rowling'),
('George Orwell'),
('Chetan Bhagat');


INSERT INTO Publishers (PublisherName) VALUES
('Penguin Books'),
('HarperCollins');


INSERT INTO Bookss (Title, AuthorID, PublisherID, PublicationYear)
VALUES
('Harry Potter', 1, 1, 1997),
('1984', 2, 1, 1949),
('Half Girlfriend', 3, 2, 2014);


INSERT INTO Sales (BookID, SaleDate, SaleAmount)
VALUES
(1, '2024-01-01', 500.00),
(1, '2024-02-15', 700.00),
(2, '2024-03-10', 300.00),
(3, '2024-03-12', 900.00),
(3, '2024-04-05', 1100.00);


SELECT B.BookID, B.Title, SUM(S.SaleAmount) AS TotalSales
FROM Bookss B
JOIN Sales S ON B.BookID = S.BookID
GROUP BY B.BookID, B.Title;


SELECT B.Title, YEAR(S.SaleDate) AS SaleYear, SUM(S.SaleAmount) AS TotalSales
FROM Bookss B
JOIN Sales S ON B.BookID = S.BookID
GROUP BY B.Title, YEAR(S.SaleDate);


SELECT B.Title, SUM(S.SaleAmount) AS TotalSales
FROM Bookss B
JOIN Sales S ON B.BookID = S.BookID
GROUP BY B.Title
HAVING SUM(S.SaleAmount) > 1000;


CREATE PROCEDURE GetBookTotalSales
    @BookTitle VARCHAR(100),
    @TotalSales DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @TotalSales = SUM(S.SaleAmount)
    FROM Bookss B
    JOIN Sales S ON B.BookID = S.BookID
    WHERE B.Title = @BookTitle
    GROUP BY B.Title;
END;

DECLARE @Output DECIMAL(10,2);

EXEC GetBookTotalSales 'Harry Potter', @Output OUTPUT;

SELECT @Output AS TotalSales;


CREATE FUNCTION GetAverageSale()
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @AvgSale DECIMAL(10,2);

    SELECT @AvgSale = AVG(SaleAmount) FROM Sales;

    RETURN @AvgSale;
END;

SELECT dbo.GetAverageSale() AS AverageSaleAmount;



