DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `CustomerInfo`(IN var_username VARCHAR(128))
BEGIN
SELECT email, first_name, middle_name, last_name, 
(select concat('(', area_code, ') ', `number`, case when extension is null then '' else concat(' x',extension) end) from PhoneNumber where Customer_UserName = var_username and type = 'home') as home_phone,
(select concat('(', area_code, ') ', `number`, case when extension is null then '' else concat(' x',extension) end) from PhoneNumber where Customer_UserName = var_username and type = 'work') as work_phone,
(select concat('(', area_code, ') ', `number`, case when extension is null then '' else concat(' x',extension) end) from PhoneNumber where Customer_UserName = var_username and type = 'cell') as cell_phone,
(concat(street, ', ', city, ', ', state, ' ', zip)) as address

FROM Customer as c
JOIN Address as a on a.id = c.Address_Id
WHERE user_name=var_username;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `ReservationsByUser`(IN var_username varchar(128))
BEGIN
select r.id as reservationId, start_date, end_date, DropOffClerk_UserName, PickupClerk_UserName,
(DATEDIFF(end_date, start_date)) as numDays,
sum(deposit_price) as TotalDeposit,
sum(rental_price) as TotalRental
from Tool 
join 
(select Tool_id,Reservations_Id from ToolReservations as tr 
where tr.Reservations_Id in (select id from Reservation as r where r.Customer_UserName = var_username)) as rid
on rid.Tool_id = id
join Reservation as r on r.id = Reservations_Id
order by booking_date;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `ToolNameShortByReservationId`(in var_reservationId int)
BEGIN
select cat.name as category, ps.name as powersource, st.name as subtype, so.name as suboption
from Tool as t
join
(select Tool_id, Reservations_Id from ToolReservations as tr where tr.Reservations_Id = var_reservationId) as trr on trr.Tool_id = t.id
join SubOption as so on so.id = t.SubOption_Id
join SubType as st on st.id = t.SubType_Id
join Category as cat on cat.id = t.Category_Id
join PowerSource as ps on ps.id = t.PowerSource_Id;
END$$
DELIMITER ;