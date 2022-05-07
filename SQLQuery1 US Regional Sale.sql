Create Database Regional_sale
Use Regional_Sale
Select * from Sales
Select * From city
Select * From Product
Select * From Customer

--- Q1 Give the list of products having profit < 650000.
Select Product_Name,
Sum(Round(Unit_Price * Order_Quantity,0)) As Revenue,
Sum(Round(Unit_Cost * Order_Quantity,0)) As COGS,
Sum(Round(Unit_Price * Order_Quantity,0) - Round(Unit_Cost * Order_Quantity,0)) As Profit
From Sales Join Product 
On Sales.ProductID= Product.ProductID
Group By Product_Name
Having Sum(Round(Unit_Price * Order_Quantity,0) - Round(Unit_Cost * Order_Quantity,0))< 650000
Order By Profit

--- Q2 Show the distribution mode of SalesTeamId.
Select SalesTeamID,
Count(Case when Sales_Channel ='Online' Then OrderNumber End) As Online_Sales,
Count(Case when Sales_Channel ='Distributor' Then OrderNumber End) As Distributor,
Count(Case when Sales_Channel ='Wholesale' Then OrderNumber End) As Instore_Sale
From Sales
Where Sales_Channel In ('Online','Distributor','Wholesale')
Group By SalesTeamID

--- Q3 Show the delivery time taken to deliver the products according to the city.
Select Product_name, city_Name,
DateDiff (dd, OrderDate, DeliveryDate) As delivery_time
From Sales Inner Join Product
On Product.ProductID =Sales.ProductID Inner Join City
On City.StoreID = Sales.StoreID
Order by delivery_time Desc;

---Q4 Show the products on which the profit is > 50%.
Select Product_Name,
Sum(Round(Unit_Price * Order_Quantity,0)) As Revenue,
Sum(Round(Unit_Cost * Order_Quantity,0)) As COGS,
Sum(Round(Unit_Price * Order_Quantity,0) - Round(Unit_Cost * Order_Quantity,0))/Sum(Round(Unit_Cost * Order_Quantity,0))* 100 As Per_Profit
From Sales Join Product 
On Sales.ProductID= Product.ProductID
Group By Product_Name

--- Q5 Show the shipping time, Dispatching time and the total delivery time taken to deliver the product according too the city.
Select Product_name, city_Name,
DateDiff (dd, OrderDate, shipDate) As shipping_time,
DateDiff (dd, ShipDate, DeliveryDate) As Dispacthing_time,
DateDiff (dd, OrderDate, DeliveryDate) As Delivery_Time
From Product Inner Join sales 
On product.ProductID = Sales.ProductID Inner Join City
On City.StoreId = Sales.StoreId

---Q6 Show the top 5 customers which places the maximum orders.
Select Top 5 Customer_Names, Count(OrderNumber) As Total_Orders
From Customer Inner Join sales 
On Customer.CustomerID = Sales.CustomerID Inner Join City
On City.StoreId = Sales.StoreId
Group By Customer_Names 
Order By Total_Orders Desc;

--- Q7 Show the top 5 products which are Mostly demanded.
Select Top 5 Product_name, Count(OrderNumber) as Total_orders
From Sales  Inner Join Product 
On Sales.ProductID = Product.ProductID
Group By Product_Name
Order BY Total_Orders Desc;

Select * From Sale_Det

---Q8 Calculate the quarterly revenue of each Year.
Select DATEPART(Year, OrderDate) As Year,
DATEPART(Quarter, OrderDate) As Quarter,
Format(Sum(Revenue), 'C', 'en-US') as Total_Revenue
From Sale_Det
Where OrderDate >= '2018-05-31'
Group By DATEPART(Year, OrderDate), DATEPART(Quarter, OrderDate)
Order By Year, Quarter ;

---Q9 Calculate the quarterly profit Percenage
Select DATEPART(Year,OrderDate) As Year,
DatePart(Quarter, OrderDate) As Quarter,
Round(Sum(Profit),1) As Total_Profit,
Round(Sum(Profit)* 100/Sum(COGS),1) As Profit_Per
From Sale_Det
Where Orderdate > '2018-05-31'
Group By DATEPART(Year,OrderDate),DatePart(Quarter, OrderDate)
Order By Year, Quarter;

--- Similarly Percentage_Profit Monthly
Select DATEPART(Year,OrderDate) As Year,
DatePart(Quarter, OrderDate) As Quarter,
DateName(Month, OrderDate) As Month,
Round(Sum(Profit),1) As Total_Profit,
Round(Sum(Profit)* 100/Sum(COGS),1) As Profit_Per
From Sale_Det
Where Orderdate > '2018-05-31'
Group By DATEPART(Year,OrderDate),DatePart(Quarter, OrderDate),DateName(Month, OrderDate)
Order By Year, Quarter;

--- Q10 Find the Yearly Percentage Profit of Each City.
Select Datepart(year, OrderDate) As Year,
City_Name, Sum(Profit) As Total_Profit,
Round(Sum(Profit)*100/Sum(COGS),1) As Per_Profit
From Sale_Det Inner Join City
On Sale_Det.StoreId = City.StoreId
Where OrderDate > '2018-05-31'
Group By Datepart(year, OrderDate), City_Name
Order By Year, Per_Profit; 