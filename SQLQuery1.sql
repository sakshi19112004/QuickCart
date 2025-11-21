IF OBJECT_ID('dbo.OrderItems','U') IS NOT NULL DROP TABLE dbo.OrderItems;
IF OBJECT_ID('dbo.Orders','U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products','U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Categories','U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Users','U') IS NOT NULL DROP TABLE dbo.Users;

CREATE TABLE Users(
    Id INT IDENTITY PRIMARY KEY,
    Email NVARCHAR(256) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(256) NOT NULL,
    FullName NVARCHAR(128) NULL,
    IsAdmin BIT NOT NULL DEFAULT 0
);

CREATE TABLE Categories(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(64) NOT NULL,
    Slug NVARCHAR(64) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE Products(
    Id INT IDENTITY PRIMARY KEY,
    CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
    Name NVARCHAR(128) NOT NULL,
    Description NVARCHAR(1024) NULL,
    Price DECIMAL(18,2) NOT NULL,
    ImageUrl NVARCHAR(512) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE Orders(
    Id INT IDENTITY PRIMARY KEY,
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(Id),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    Total DECIMAL(18,2) NOT NULL,
    Status NVARCHAR(32) NOT NULL
);

CREATE TABLE OrderItems(
    Id INT IDENTITY PRIMARY KEY,
    OrderId INT NOT NULL FOREIGN KEY REFERENCES Orders(Id),
    ProductId INT NOT NULL FOREIGN KEY REFERENCES Products(Id),
    ProductName NVARCHAR(128) NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    Quantity INT NOT NULL,
    LineTotal AS (UnitPrice * Quantity) PERSISTED
);

-- Seed admin and categories/products
INSERT INTO Users(Email,PasswordHash,FullName,IsAdmin)
VALUES('admin@quickcart.local','8d969eef6ecad3c29a3a629280e686cff8fabd...','Admin',1); -- REPLACE with SHA256('123456') in app or put real hash

-- simple categories
INSERT INTO Categories(Name,Slug) VALUES
(N'Grocery','grocery'),(N'Snacks','snacks'),(N'Beverages','beverages'),(N'Beauty','beauty'),(N'Home','home'),(N'Electronics','electronics');

-- sample products
INSERT INTO Products(CategoryId,Name,Description,Price,ImageUrl) VALUES
(1,N'Atta 5kg',N'Whole wheat flour',289,'https://placehold.co/300x200?text=Atta'),
(1,N'Basmati Rice 1kg',N'Premium long grain',139,'https://placehold.co/300x200?text=Rice'),
(2,N'Potato Chips 100g',N'Classic salted',45,'https://placehold.co/300x200?text=Chips'),
(3,N'Orange Juice 1L',N'No added sugar',119,'https://placehold.co/300x200?text=Juice'),
(4,N'Herbal Shampoo',N'Paraben free',199,'https://placehold.co/300x200?text=Shampoo'),
(6,N'USB-C Cable',N'Fast charge 1m',149,'https://placehold.co/300x200?text=Cable');
