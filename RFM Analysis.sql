-- RFM
With Agg_byCust as (
Select CustomerKey
, Sum(SalesAmount) as Monetary
, Count(SalesOrderNumber) as Frequency
, Max(OrderDate) as LastOrderDate -- Phục vụ tính Recency
, Datediff(DAY,Max(OrderDate), (Select Max(OrderDate) From dbo.sales_sample_data) ) as Recency -- Lấy chênh lệch giữa ngày đặt đơn gần nhất của khách và thời điểm gần nhất của dataset)
From dbo.sales_sample_data
Group by CustomerKey
)

, RFM_Calc as (
Select CustomerKey
, NTILE(4) over (Order by Recency desc) as R_Score
, NTILE(4) over (Order by Monetary) as M_Score
, NTILE(4) over (Order by Frequency) as F_Score
From Agg_byCust
)

, RFM_Score as (
Select CustomerKey
, Concat(R_Score, F_Score, M_Score) as RFM_score
From RFM_Calc
)
-- Lost customer Mua từ rất lâu rồi, Recency thấp - 1xx
-- Big spenders Mua với giá trị đơn hàng lớn nhưng tấn suất mua ít - X14, X24 
-- Promising Mua gần đây, tần suất nhiều nhưng giá trị đơn hàng còn thấp - [3,4][3,4][1,2]
-- New customer Mua gần đây, tần suất thấp - [3,4][1,2]_ 
-- Potential churn (Có khả năng rời bỏ) Mua từ khá lâu rồi, Recency khá thấp- 2XX
-- Loyal Mua gần đây, tần suất cao, giá trị đơn cao - [34][34][34]

, RFM_Segmentation as (
Select CustomerKey
, RFM_Score
, 
case
When RFM_Score like '1__' then 'Lost Customer'
When RFM_Score like '_[1,2]4' then 'Big Spenders'
When RFM_Score like '[3,4][3,4][1,2]' then 'Promising'
When RFM_Score like '[3,4][1,2]_' then 'New Customer'
When RFM_Score like '2__' then 'Potential Churn'
When RFM_Score like '[3,4][3,4][3,4]' then 'Loyal'
end as CustomerSegmentation
From RFM_score
)

Select CustomerSegmentation
, Count(CustomerKey) as TotalCustomers
From RFM_Segmentation
Group by CustomerSegmentation


