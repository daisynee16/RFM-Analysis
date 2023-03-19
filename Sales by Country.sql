-- Quốc gia đem lợi profit, revenue cao nhất
Select Country
, Sum(SalesAmount) as TotalSales
, Sum(Cost) as TotalCost
, Sum(Profit) as TotalProfit
From dbo.sales_sample_data
Group by Country
Order by TotalProfit asc