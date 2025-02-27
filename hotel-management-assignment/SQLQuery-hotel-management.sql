use JIBE_Main_Training;

create table Hotel_Customers_2003(
	CustomerId int primary key,
	Name varchar(50),
	Email varchar(50),
	Phone char(10),
	Address varchar(100)
);

create table Hotel_Rooms_2003(
	RoomId int primary key,
	RoomType varchar(20),
	PricePerNight decimal(10, 2),
	Status varchar(20) check(Status in ('Available', 'NotAvailable'))
);

create table Hotel_Bookings_2003(
	BookingId int identity(1,1) primary key,
	CustomerId int,
	RoomId int,
	CheckInDate date,
	CheckOutDate date,
	TotalAmount decimal(10, 2),
	Foreign key (CustomerId) references Hotel_Customers_2003(CustomerId),
	Foreign key (RoomId) references Hotel_Rooms_2003(RoomId)
);

create table Hotel_Payments_2003(
	PaymentId int identity(1,1) primary key,
	BookingId int,
	PaymentDate date,
	Amount decimal(10, 2),
	PaymentMethod varchar(20),
	Foreign key (BookingId) references Hotel_Bookings_2003(BookingId)
);

create table Hotel_Employee_2003(
	EmployeeId int primary key,
	Name varchar(50),
	Position varchar(20),
	Salary decimal(10, 2),
	HireDate date,
	ManagerId int,
	Foreign key (ManagerId) references Hotel_Employee_2003(EmployeeId)
);

create table Hotel_Services_2003(
	ServiceId int primary key,
	ServiceName varchar(50),
	Price decimal(10, 2)
);

create table Hotel_Services_Booking(
	ServiceId int foreign key references Hotel_Services_2003(ServiceId),
	BookingId int foreign key references Hotel_Bookings_2003(BookingId),
	quantity int
);

select * from Hotel_Services_Booking;

create table Hotel_Branch_2003(
	BranchId int primary key,
	BranchName varchar(50),
	LocationDecription varchar(100)
);


-- 1. Data Insertion

insert into Hotel_Customers_2003 (CustomerId, Name, Email, Phone, Address) values
(1, 'Virat Kohli', 'virat@gmail.com', '1234567890', '123 Main St'),
(2, 'Rohit Sharma', 'rohit@gmail.com', '0987654321', '456 Elm St'),
(3, 'K. L. Rahul', 'rahul@gmail.com', '1112223333', '789 Oak St'),
(4, 'Rishab Pant', 'rishab@gmail.com', '4445556666', '321 Pine St'),
(5, 'Axar Patel', 'axar@gmail.com', '7778889999', '654 Cedar St');

insert into Hotel_Rooms_2003 (RoomId, RoomType, PricePerNight, Status) values (106, 'Double', 700.00, 'Available');

select * from Hotel_Rooms_2003;



insert into Hotel_Bookings_2003 (CustomerId, RoomId, CheckInDate, CheckOutDate, TotalAmount) values
(1, 101, '2025-01-01', '2025-01-05', 2000.00),
(2, 102, '2025-02-01', '2025-02-05', 3000.00),
(3, 103, '2025-03-01', '2025-03-05', 6000.00),
(4, 104, '2025-04-01', '2025-04-05', 2000.00),
(5, 105, '2025-05-01', '2025-05-05', 3000.00);

insert into Hotel_Payments_2003 (BookingId, PaymentDate, Amount, PaymentMethod)values
(1, '2025-01-06', 2000.00, 'Credit Card'),
(2, '2025-02-06', 3000.00, 'UPI'),
(3, '2025-03-06', 6000.00, 'Cash'),
(4, '2025-04-06', 2000.00, 'Credit Card'),
(5, '2025-05-06', 3000.00, 'UPI');

insert into Hotel_Employee_2003 (EmployeeId, Name, Position, Salary, HireDate, ManagerId) values
(1, 'Shri Nashte', 'Manager', 50000.00, '2020-01-01', null),
(2, 'Jay Gajarkar', 'Receptionist', 30000.00, '2021-02-01', 1),
(3, 'Omkar Bagal', 'Housekeeper', 25000.00, '2021-03-01', 1),
(4, 'Auysh Koli', 'Chef', 35000.00, '2022-04-01', 1),
(5, 'Lavanya Satpute', 'Security', 30000.00, '2022-05-01', 1);

insert into Hotel_Branch_2003 (BranchId, BranchName, LocationDecription) values
(1, 'Mumbai Central', 'Near Central Station, Mumbai'),
(2, 'Pune West', 'Next to Pune University, Pune'),
(3, 'Kohapur', 'Mahalakshi Temple, Rankala Lake, Mountans,Kohapur'),
(4, 'Chennai Beach', 'Close to Marina Beach, Chennai'),
(5, 'Navi Mumbai', 'Near Flemingo point Beach, Navi Mumbai');

select * from Hotel_Rooms_2003;
-- 2. Queries using joins.

-- Customer Booking Details.
select Hotel_Customers_2003.Name, Hotel_Rooms_2003.RoomType, Hotel_Bookings_2003.CheckInDate, Hotel_Bookings_2003.TotalAmount
from Hotel_Customers_2003 
inner join Hotel_Bookings_2003 on Hotel_Customers_2003.CustomerId = Hotel_Bookings_2003.CustomerId
inner join Hotel_Rooms_2003 on Hotel_Bookings_2003.RoomId = Hotel_Rooms_2003.RoomId;

-- Employee list with managers.
select emp.Name as Employee, emp.Position, man.Name as Manager
from Hotel_Employee_2003 as emp
left join Hotel_Employee_2003 as man on emp.ManagerId = man.EmployeeId;

-- Rooms that never booked.
select Hotel_Rooms_2003.RoomId, Hotel_Rooms_2003.RoomType
from Hotel_Rooms_2003 left join Hotel_Bookings_2003 on  Hotel_Rooms_2003.RoomId = Hotel_Bookings_2003.RoomId where BookingID is NULL;


-- 3. Subqueries.


-- Most Expencive Room booked.
select * from Hotel_Rooms_2003 where PricePerNight = (select max(PricePerNight)from Hotel_Rooms_2003 where RoomId in (select RoomId from Hotel_Bookings_2003));

-- Views
create view Active_Booking_2003_ as
select 
	Hotel_Customers_2003.Name,
	Hotel_Rooms_2003.RoomType, 
	Hotel_Bookings_2003.CheckInDate,
	Hotel_Bookings_2003.CheckOutDate
from Hotel_Customers_2003 
inner join Hotel_Bookings_2003 on Hotel_Customers_2003.CustomerId = Hotel_Bookings_2003.CustomerId
inner join Hotel_Rooms_2003 on Hotel_Bookings_2003.RoomId = Hotel_Rooms_2003.RoomId;
	
select * from Active_Booking_2003_;

-- Customers with multiple bookings.
select * from Hotel_Bookings;
select CustomerId, Name, Email
from Hotel_Customers
where CustomerId in (
    select CustomerId
    from Hotel_Bookings
    group by CustomerId
    having count(BookingId) > 1);

-- 5. Indexing 

-- Create Index on RoomType
create index Rooms_idx_2003 on Hotel_Rooms_2003(RoomType);

-- Create Composite index on CheckInDate, CheckOutDate
create index CheackInAndOut_idx_2003 on Hotel_Bookings_2003(CheckInDate, CheckOutDate);


-- 6. Stored Procedures and Functions.

-- Create Stored procedure to get total revenue generate in month.
create procedure sp_CalculateMonthlyRevenue_2003(
    @Year int,
    @Month int
)
as
begin
    select sum(Amount) as TotalRevenue_In_Month
    from Hotel_Payments_2003
    where year(PaymentDate) = @Year and month(PaymentDate) = @Month;
end;

exec sp_CalculateMonthlyRevenue_2003 @Year = 2025, @Month = 3;

-- Create UD Function to calculate the total number of days customer stayed.
create function fn_CalculateTotalDays_2003(
    @CustomerId int
)
returns int
as
begin
    declare @TotalDays int;

    select @TotalDays = sum(datediff(day, CheckInDate, CheckOutDate))
    from Hotel_Bookings_2003
    where CustomerId = @CustomerId;

    return @TotalDays;
end;

select dbo.fn_CalculateTotalDays_2003(1);

-- Trigger
drop trigger trg_CancelBooking_2003_;

create trigger trg_CancelBooking_2003
on Hotel_Bookings_2003
instead of delete
as 
begin
	update Hotel_Rooms_2003
	set Status = 'Available'
	where RoomId = (select RoomId from deleted);
	print 'Booking Canceled !';
end;

delete from Hotel_Bookings_2003 where BookingId = 8;

select * from Hotel_Rooms_2003;

-- trigger on insert in booking
drop trigger trg_Booking_Insert_2003_;
create trigger trg_Booking_Insert_2003_
on Hotel_Bookings_2003
instead of insert
as
begin
    if exists (
        select 1 
        from Hotel_Rooms_2003 r
        join inserted i on r.RoomId = i.RoomId
        where r.Status = 'Available'
    )
    begin
        insert into Hotel_Bookings_2003 (CustomerId, RoomId, CheckInDate, CheckOutDate, TotalAmount)
        select CustomerId, RoomId, CheckInDate, CheckOutDate, TotalAmount
        from inserted;

        update Hotel_Rooms_2003
        set Status = 'NotAvailable'
        where RoomId in (select RoomId from inserted);

        print 'Booking Successful!';
    end
    else
    begin
        print 'Room is not available!';
    end
end;
select * from Hotel_Bookings_2003;
insert into Hotel_Bookings_2003 (CustomerId, RoomId, CheckInDate, CheckOutDate, TotalAmount) values (5, 106, '2025-01-01', '2025-01-05', 2000.00);

select * from Hotel_Rooms_2003;

select * from Hotel_Bookings_2003;
delete from Hotel_Bookings_2003 where BookingId = 7;
-- Full Text Search
select * from Hotel_Branch_2003;
select * from Hotel_Branch_2003 where LocationDecription like '%Mahalakshi%';

exec sp_help Hotel_Branch_2003;

create fulltext index on Hotel_Branch_2003(LocationDecription) key index PK__Hotel_Br__A1682FC5BF067399;



select * from Hotel_Branch_2003 where contains(LocationDecription, 'Beach');