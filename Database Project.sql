create database EcommerceDB301;
use EcommerceDB301;

create table Customers301(
customer_ID int primary key,
Name varchar(100),
Email varchar(100),
City varchar(50)
);

create table Categories301(
category_ID int primary key,
category_Name varchar(100)
);

create table Products301(
product_ID int primary key,
product_Name varchar(100),
product_Price Decimal(10, 2),
stock int,
category_ID int,
foreign key (category_ID) references Categories301 (category_ID)
);

create table Orders301(
order_ID int primary key,
customer_ID int,
order_Date date,
total_Amount Decimal(10, 2),
foreign key (customer_ID) references Customers301 (customer_ID)
);

create table Order_Items301(
order_item_ID int primary key,
order_ID int,
product_ID int,
quantity int,
product_Price Decimal(10, 2),
foreign key (order_ID) references Orders301 (order_ID),
foreign key (product_ID) references Products301 (product_ID)
);

insert into Customers301 (customer_ID, Name, Email, City) values
(1, 'Maaz', 'maazsahab277@gmail.com', 'Karachi'),
(2, 'Jibraan', 'jibranzahid8909@gmail.com', 'Lahore'),
(3, 'Shafay', 'shafayshaz842@gmail.com', 'Islamabad');

insert into Categories301 (category_ID, category_Name) values
(1, 'Electronics'),
(2, 'Fashion'),
(3, 'Jewelry');

insert into Products301 (product_ID, product_Name, product_Price, stock, category_ID) values
(1, 'Mobile Phone', 20000, 50, 1),
(2, 'Laptop', 12000, 30, 2),
(3, 'Shoes', 2000, 39, 3);

insert into Orders301 (order_ID, customer_ID, order_Date, total_Amount) values
(1, 1, '2024-01-10', 25000),
(2, 2, '2025-01-29', 5000);

insert into Order_Items301 (order_item_ID, order_ID, product_ID, quantity, product_Price) values
(1, 1, 1, 2, 4000),
(2, 2, 3, 4, 3000);

--ye wala sb kuch run krny ke baad isko run krna mtlb last wala select statement run krny
-- ky baad wo is lya kyn ki ye run hoga triggers ky lya 
insert into Order_Items301 (order_item_ID, order_ID, product_ID, quantity, product_Price) values
(3, 1, 1, 1, 4000);


SELECT * FROM Orders301;
SELECT * FROM Products301;

--Inner Join

select o.order_ID, c.Name, p.product_Name, oi.quantity
from Orders301 o
Inner Join Customers301 c on o.customer_ID = c.customer_ID
Inner Join Order_Items301 oi on o.order_ID = oi.order_ID
Inner Join Products301 p on p.product_ID = oi.product_ID;

--Left Join

select p.product_Name, oi.order_id
from Products301 p
Left Join Order_Items301 oi
on p.product_ID = oi.product_ID;

-- Customers who spent more than average

select Name, Email, City
from Customers301
where customer_ID in (
       select customer_ID
       from Orders301
       where total_Amount > (
             select Avg(total_Amount)
             from Orders301
       )
);

-- Products never ordered

select product_Name, product_ID
from Products301
where product_ID not in (
        select product_ID
        from Order_Items301
);

-- Views

create view Customers301_Orders_View as
select c.Name, count(o.order_ID) as total_orders
from Customers301 c
Left Join Orders301 o 
on c.customer_ID = o.customer_ID
Group By c.Name;

select * from Customers301_Orders_View

create view Products301_Sales_View as
select p.product_Name, sum(oi.quantity) as total_solds
from Products301 p
Left Join Order_Items301 oi
on p.product_ID = oi.product_ID
Group By p.product_Name;

select * from Products301_Sales_View

-- Indexes

create index idx_customers_emails on Customers301(Email);
create index idx_product_price on Products301(product_Price);

select * from Customers301 where Email = 'jibranzahid8909@gmail.com';
select * from Products301 where product_Price > 5000;


-- Triggers


create trigger Reduce_Stock_After_Orders1
on Order_Items301
After Insert
As
Begin
    Update Products301
    set stock = stock - i.quantity
    from Products301 p
    Inner Join inserted i
    ON p.product_ID = i.product_ID;
End;

SELECT product_Name, stock FROM Products301 WHERE product_ID = 1;
