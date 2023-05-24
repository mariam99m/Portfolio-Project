﻿-- გამოიტანე ყველა ისეთი კლიენტის სახელი რომელიც არის Customers ცხრილში, მაგრამ არ არის Orders ცხრილში.
select  CustomerName from Customers c
left join Orders o on c.CustomerID=o.CustomerID
where c.CustomerID is not null


-- წამოიღე თითოეული მიმწოდებლისთვის ტოპ 2 ყველაზე ძვირიანი  პროდუქტების სახელები და ფასები. Suppliers, Products
-- იმ შემთხვევაში თუ ფასი იქნება 20-ზე ნაკლები სვეტში ჩამიწეროს დაბალი, 20-დან 40-მდე - საშუალო, 40ზე მეტი მაღალი
select SupplierID,
       productname,
       price,
       case when price<20 then N'დაბალი'
	        when price between 20 and 40 then N'საშუალო'
			when price>40 then N'მაღალი'
			end m
 from (
			select s.SupplierID,
					productname,
					price,
					row_number() over(partition by s.supplierid order by price desc) rn 
					from Suppliers s
			join products p on s.SupplierID=p.SupplierID ) procdt
 where rn in (1,2)



 --გამოიტანეთ სახელები და მთლიანი გაყიდვები ყველა თანამშრომლისთვის, რომლებმაც გაყიდეს პროდუქტები.
--გაყიდვა ნიშნავს ფასი გამრავლებული რაოდენობაზე [dbo].[Products], OrderDetails, შეიძლება სხვა ცხრილებიც დაგჭირდეს
select o.employeeid, 
       sum(quantity*price) gayidvebi

from OrderDetails o1
join Products p on o1.ProductID=p.ProductID
join orders o on o1.OrderID=o.OrderID
group by o.employeeid



--გამოიტანეთ ისეთი კლიენტების სახელები რომლებსაც სამი ან მეტი განსხვავებული პროდუქტი აქვთ შეძენილი 1996 წლის ოქტომბრიდან 1997 წლის ნოემბრამდე
--Customers  Orders  OrderDetails
select customername,
       count(distinct productid) cnt
	   from Orders o
join OrderDetails o1 on o.OrderID=o1.OrderID
join Customers c on o.CustomerID=c.CustomerID
where orderdate between '1996-10-01' and '1997-11-01'
group by CustomerName 
having count (distinct productid)>=3



create PROCEDURE customerss
@Start_Date date,
@End_Date date
AS
BEGIN

	select customername,
		   count(distinct productid) cnt
		   from Orders o
	join OrderDetails o1 on o.OrderID=o1.OrderID
	join Customers c on o.CustomerID=c.CustomerID
	where orderdate between @Start_Date and @End_Date
	group by CustomerName 
	having count (distinct productid)>=3

END