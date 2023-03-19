-- Câu hỏi có thể đặt ra từ dataset
  -- Doanh thu có tăng trưởng theo thời gian hay không ? =>> Doanh nghiệp gặp vấn đề trong việc quản lí cost, doanh thu cao tuy nhiên cost cũng kéo theo cao => profit ko tăng trưởng đáng kể
  -- Quốc gia nào đang đem lại lợi nhuận, doanh thu cao nhất ?
  -- Xác định khách hàng theo từng tập, sử dụng RFM ?
  -- Tính chỉ tiêu theo từng tháng
Select
  Year,
  Month,
  MonthName,
  Sum(SalesAmount) as TotalSales,
  Sum(Profit) as TotalProfit,
  Sum(Cost) as TotalCost,
  Count(SalesOrderNumber) as TotalOrders,
  Sum(SalesAmount) / Count(SalesOrderNumber) as AOV
From
  dbo.sales_sample_data
Group by
  Year,
  Month,
  MonthName
Order by
  Year desc,
  Month desc 
  -- Sales Trending by Month => Sales có tăng trưởng cao vào 2 tháng đầu năm 2020
  -- Total Revenue, Total Orders => Doanh thu giảm, số đơn tăng => Dự kiến nguyên nhân do giá trị trung bình mỗi đơn hàng giảm
  -- Trending AOV 
  -- => Kết luận: Tổng doanh thu giảm do Số lượng đơn tăng nhưng AOV còn nhỏ 
  -- => Cần đẩy AOV lên để tăng doanh thu => Chia nhóm KH để xác định đẩy AOV nhóm nào, ko đẩy hết