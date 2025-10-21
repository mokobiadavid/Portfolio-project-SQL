-- Calendar Dimension Table

SELECT [DateKey]
      ,[FullDateAlternateKey] as date,
      --,[DayNumberOfWeek]
      [EnglishDayNameOfWeek] as Day,
      --,[SpanishDayNameOfWeek]
      --,[FrenchDayNameOfWeek]
      --,[DayNumberOfMonth]
      --,[DayNumberOfYear]
      [WeekNumberOfYear] as WeekNo
      ,[EnglishMonthName] as Month,
      left([EnglishMonthName],3) as MonthShort
      --,[SpanishMonthName]
      --,[FrenchMonthName]
      ,[MonthNumberOfYear] as MonthNo
      ,[CalendarQuarter] as Quarter
      ,[CalendarYear] as Year
      --,[CalendarSemester]
      --,[FiscalQuarter]
      --,[FiscalYear]
      --,[FiscalSemester]
  FROM [AdventureWorksDW2022].[dbo].[DimDate]
  Where CalendarYear >= 2023


  --cleansed customer table
SELECT 
c.customerkey As customerkey,

      --,[GeographyKey]
      --,[CustomerAlternateKey]
      --,[Title]
      c.firstname as [First Name],
      --,[MiddleName]
      c.lastname as [Last Name],
      c.firstname + ' ' + lastname as [Full Name],
-- Combined first and last name
--      ,[NameStyle]
--      ,[BirthDate]
--      ,[MaritalStatus]
--      ,[Suffix]
case c.gender when 'M' then 'Male' when 'F' then 'Female' end as Gender,
--      ,[EmailAddress]
--      ,[YearlyIncome]
--     ,[TotalChildren]
--      ,[NumberChildrenAtHome]
--      ,[EnglishEducation]
--      ,[SpanishEducation]
--      ,[FrenchEducation]
--      ,[EnglishOccupation]
      --,[SpanishOccupation]
      --,[FrenchOccupation]
      --,[HouseOwnerFlag]
      --,[NumberCarsOwned]
      --,[AddressLine1]
      --,[AddressLine2]
      --,[Phone]
c.datefirstpurchase as DateFirstPurchase,
--      ,[CommuteDistance]
g.city as [Customer City] -- Joined in customer city from Geography table  
from
dbo.DimCustomer as c
left join dbo.DimGeography as g on g.GeographyKey = c.GeographyKey
order by
CustomerKey ASC -- ordered list of customerkey


-- cleansed DIM_products table --
SELECT 
p.[ProductKey],
p.[ProductAlternateKey] as ProductItemCode,
--      ,[ProductSubcategoryKey]
--      ,[WeightUnitMeasureCode]
--      ,[SizeUnitMeasureCode]
[EnglishProductName] as [Product Name],
ps.EnglishProductSubcategoryName AS [Sub Category], -- Joined in from sub category table
EnglishProductCategoryName as [Product Category], -- Joined in from category table
--      ,[SpanishProductName]
--      ,[FrenchProductName]
--      ,[StandardCost]
--      ,[FinishedGoodsFlag]
      p.[Color] as [Product color],
--      ,[SafetyStockLevel]
--      ,[ReorderPoint]
--      ,[ListPrice]
      p.[Size] as [Product size],
--      ,[SizeRange]
--      ,[Weight]
--      ,[DaysToManufacture]
      p.[ProductLine] as [Product Line],
--      [DealerPrice]
--      ,[Class]
--      ,[Style]
p.[ModelName] as [Product Model Name],
--      ,[LargePhoto]
p.[EnglishDescription] as [Product Description],
--      ,[FrenchDescription]
--      ,[ChineseDescription]
--      ,[ArabicDescription]
--     ,[HebrewDescription]
--      ,[ThaiDescription]
--      ,[GermanDescription]
--      ,[JapaneseDescription]
--     ,[TurkishDescription]
--      ,[StartDate]
--      ,[EndDate]
isnull (p.Status, 'Outdated')as [Product Status]
  FROM [AdventureWorksDW2022].[dbo].[DimProduct] as p
  left join [AdventureWorksDW2022].dbo.DimProductSubcategory as ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
  left join [AdventureWorksDW2022].dbo.DimProductCategory as pc on ps.ProductCategoryKey = pc.ProductCategoryKey
  order by 
  p.ProductKey asc


  -- Cleansed FACT_InternetSales Table --
SELECT 
  [ProductKey], 
  [OrderDateKey], 
  [DueDateKey], 
  [ShipDateKey], 
  [CustomerKey], 
  --  ,[PromotionKey]
  --  ,[CurrencyKey]
  --  ,[SalesTerritoryKey]
  [SalesOrderNumber], 
  --  [SalesOrderLineNumber], 
  --  ,[RevisionNumber]
  --  ,[OrderQuantity], 
  --  ,[UnitPrice], 
  --  ,[ExtendedAmount]
  --  ,[UnitPriceDiscountPct]
  --  ,[DiscountAmount] 
  --  ,[ProductStandardCost]
  --  ,[TotalProductCost] 
  [SalesAmount] --  ,[TaxAmt]
  --  ,[Freight]
  --  ,[CarrierTrackingNumber] 
  --  ,[CustomerPONumber] 
  --  ,[OrderDate] 
  --  ,[DueDate] 
  --  ,[ShipDate] 
FROM 
  [AdventureWorksDW2022].[dbo].[FactInternetSales]
WHERE 
  LEFT (OrderDateKey, 4) >= YEAR(GETDATE()) -2 -- Ensures we always only bring two years of date from extraction.
ORDER BY
  OrderDateKey ASC
