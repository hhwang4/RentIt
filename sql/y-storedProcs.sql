use cs6400_sfa17_team033;

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
group by Reservations_Id
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

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `ClerkReport`(in var_month int, in var_year int)
BEGIN
select first_name, middle_name, last_name, email, date_of_hire, employee_number,
(select count(PickupClerk_UserName) from Reservation as r where r.PickupClerk_UserName = c.user_name and MONTH(r.booking_date) = var_month and YEAR(r.booking_date) = var_year) as numPickups,
(select count(DropOffClerk_UserName) from Reservation as q where q.DropOffClerk_UserName = c.user_name and MONTH(q.booking_date) = var_month and YEAR(q.booking_date) = var_year) as numDropOffs,

# For some reason this syntax isn't working and it should (numPickups + numDropOffs) as CombinedTotal 
# So instead use ugly syntax
((select count(PickupClerk_UserName) from Reservation as r where r.PickupClerk_UserName = c.user_name and MONTH(r.booking_date) = var_month and YEAR(r.booking_date) = var_year) 
+ 
(select count(DropOffClerk_UserName) from Reservation as q where q.DropOffClerk_UserName = c.user_name and MONTH(q.booking_date) = var_month and YEAR(q.booking_date) = var_year)
) as CombinedTotal
from Clerk as c
order by numPickups DESC, numDropOffs DESC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `CustomerReport`(in var_month int, in var_year int)
BEGIN
select id, first_name, middle_name, last_name, email, user_name,
(select concat('(', area_code, ') ', `number`, case when extension is null then '' else concat(' x',extension) end) from PhoneNumber as p where p.Customer_UserName = c.user_name and p.primary = true) as phone,
(select count(Customer_UserName) from Reservation as r where r.Customer_UserName = c.user_name and MONTH(r.booking_date) = var_month and YEAR(r.booking_date) = var_year) as totalReservations,
(select count(Tool_id) from ToolReservations as tr where tr.Reservations_Id in
(select id from Reservation as r where r.Customer_UserName = c.user_name and MONTH(r.booking_date) = var_month and YEAR(r.booking_date) = var_year)) as ToolsRented
from Customer as c
order by ToolsRented, last_name;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `ToolInventoryReport`(in var_ipp int, in var_pagenum int, in var_date datetime)
BEGIN
select t.id as toolId, 
concat_ws(' ',so.name, st.name) as description,
EXISTS(select id from Tool t2 where t.id = t2.id 
and t2.id not in (select Tool_Id from Rentals as r where r.Tool_Id = t.id and r.end_date is NULL)
and t2.id not in (select id from ServiceOrder as so where so.Tool_Id = t2.id and so.end_date > var_date )
and t2.id not in (select id from SaleOrder as so where so.sold_date is NULL and so.Tool_Id = t2.id)
) as available,
EXISTS(select Tool_Id from Rentals as r where r.Tool_Id = t.id and r.end_date is NULL) as rented,
EXISTS(select id from ServiceOrder as so where so.Tool_Id = t.id and so.end_date > var_date ) as inrepair,
EXISTS(select id from SaleOrder as so where so.sold_date is NULL and so.Tool_Id = t.id) as forsale,
EXISTS(select id from SaleOrder as so where so.sold_date is not NULL and so.Tool_Id = t.id) as sold,
(select sold_date from SaleOrder as so where so.sold_date is not NULL and so.Tool_Id = t.id) as soldDate,
(select sold_date from SaleOrder as so where so.sold_date is NULL and so.Tool_Id = t.id) as forsaleDate,
(select start_date from ServiceOrder as so where so.Tool_Id = t.id and so.end_date > var_date ) as inrepairDate,
(select res.end_date from Rentals as r join ToolReservations as tr on r.Tool_id = tr.Tool_id join Reservation as res on tr.Reservations_Id = res.id where tr.Tool_id = t.id and tr.Tool_id in (select tool_id from Rentals where end_date is null) and r.end_date is NULL order by res.end_date desc limit 1) as rentedDate,
(IFNULL((select sum(DATEDIFF(end_date, start_date)) from Reservation as r join ToolReservations as tr on tr.Reservations_Id = r.id where t.id = tr.Tool_Id),0) * rental_price) as RentalProfit,
(t.original_price + IFNULL((select sum(service_cost) from ServiceOrder as so where so.Tool_Id = t.id),0)) as TotalCost,
((IFNULL((select sum(DATEDIFF(end_date, start_date)) from Reservation as r join ToolReservations as tr on tr.Reservations_Id = r.id where t.id = tr.Tool_Id),0) * rental_price)
- (t.original_price + IFNULL((select sum(service_cost) from ServiceOrder as so where so.Tool_Id = t.id),0))
) as TotalProfit,
c.name
from Tool as t
join SubOption as so on so.id = t.SubOption_Id
join SubType as st on st.id = t.SubType_Id
join Category as c on c.id = t.Category_Id
order by TotalProfit DESC
LIMIT var_pagenum,var_ipp;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `ToolDetails`(IN var_toolid int)
BEGIN
SELECT
	tool.id as toolId,
    category.name as category,
	CONCAT(
		COALESCE(powersource.name, ''), ' ',
		COALESCE(suboption.name, ''), ' ',
		COALESCE(subtype.name, '')
	) as short_desc,
	CONCAT(
		COALESCE(width, ''), ' in. W x',
		COALESCE(length, ''), 'in. L ',
		CONCAT(COALESCE(weight, ''), 'lb'), ' ',
		COALESCE(other_desc.other_desc, ''), ' ',
		COALESCE(
			IF(
				powersource.name='A/C','electric',
				IF(
					powersource.name='D/C', 'cordless',
					powersource.name
				)
			),
            ''), ' ',
		COALESCE(suboption.name, ''), ' ',
		COALESCE(subtype.name, ''), ' ',
		CONCAT('By ', COALESCE(manufacturer, '')), ' '
	) as full_desc,
    powersource.name as powersource,
    subtype.name as subtype, suboption.name as suboption,
    rental_price,
    deposit_price,
    material,
    width,
    weight,
    length,
    manufacturer,
    accessory.description as acc_description
FROM Tool as tool
JOIN SubOption as suboption ON suboption.id = tool.SubOption_Id
JOIN SubType as subtype ON subtype.id = tool.SubType_Id
JOIN PowerSource as powersource ON powersource.id = tool.PowerSource_Id
JOIN Category as category ON category.id = tool.Category_Id
LEFT OUTER JOIN Accessory as accessory ON accessory.PowerTool_Id = tool.id
JOIN (

	SELECT
		CONCAT(
			COALESCE(CONCAT(gauge_rating, 'G'), ''), ' ',
			COALESCE(capacity, '')
		) AS other_desc
	FROM HandGun
	WHERE id = var_toolid
	UNION
	SELECT
		anti_vibration AS other_desc
	FROM HandHammer
	WHERE id = var_toolid
	UNION
	SELECT
		adjustable AS other_desc
	FROM HandPlier
	WHERE id = var_toolid
	UNION
	SELECT
		CONCAT(drive_size, 'in') AS other_desc
	FROM HandRatchet
	WHERE id = var_toolid
	UNION
	SELECT
		CONCAT('#', screw_size)AS other_desc
	FROM ScrewDriver
	WHERE id = var_toolid
	UNION
	SELECT
		CONCAT(
			COALESCE(CONCAT(drive_size, 'in'), ''), ' ',
			COALESCE(CONCAT(sae_size, 'in'), ''), ' ',
			COALESCE(deep_socket, '')
		) AS other_desc
	FROM HandSocket
	WHERE id = var_toolid
	UNION
	SELECT
		CONCAT(
			COALESCE(CONCAT(tank_size, 'gal'), ''), ' ',
			COALESCE(CONCAT(pressure_rating, 'psi'), ''), ' ',
			COALESCE(CONCAT(volt_rating, 'V'), ''), ' ',
			COALESCE(CONCAT(amp_rating, 'Amp'), ''), ' ',
			COALESCE(CONCAT(min_rpm_rating, 'min rpm'), ''), ' ',
			COALESCE(CONCAT(max_rpm_rating, 'max rpm'), '')
		) AS other_desc
	FROM PowerAirCompressor pa
	JOIN PowerTool pt ON pt.id = pa.id
	WHERE pt.id = var_toolid
	UNION
	SELECT
		CONCAT(
			COALESCE(adjustable_clutch, ''), ' ',
			COALESCE(CONCAT(min_torque_rating, 'ft-lb'), ''), ' ',
			COALESCE(CONCAT(max_torque_rating, 'ft-lb'), ''), ' ',
			COALESCE(CONCAT(volt_rating, 'V'), ''), ' ',
			COALESCE(CONCAT(amp_rating, 'Amp'), ''), ' ',
			COALESCE(CONCAT(min_rpm_rating, 'min rpm'), ''), ' ',
			COALESCE(CONCAT(max_rpm_rating, 'max rpm'), '')
		) AS other_desc
	FROM PowerDrill pa
	JOIN PowerTool pt ON pt.id = pa.id
	WHERE pt.id = var_toolid
	UNION
	SELECT
		CONCAT(
			COALESCE(CONCAT(power_rating, 'Watts'), ''), ' ',
			COALESCE(CONCAT(volt_rating, 'V'), ''), ' ',
			COALESCE(CONCAT(amp_rating, 'Amp'), ''), ' ',
			COALESCE(CONCAT(min_rpm_rating, 'min rpm'), ''), ' ',
			COALESCE(CONCAT(max_rpm_rating, 'max rpm'), '')
		) AS other_desc
	FROM PowerGenerator pa
	JOIN PowerTool pt ON pt.id = pa.id
	WHERE pt.id = var_toolid
	UNION
	SELECT
		CONCAT(
			COALESCE(CONCAT(motor_rating, 'HP'), ''), ' ',
			COALESCE(CONCAT(drum_size, 'cu ft.'), ''), ' ',
			COALESCE(CONCAT(volt_rating, 'V'), ''), ' ',
			COALESCE(CONCAT(amp_rating, 'Amp'), ''), ' ',
			COALESCE(CONCAT(min_rpm_rating, 'min rpm'), ''), ' ',
			COALESCE(CONCAT(max_rpm_rating, 'max rpm'), '')
		) AS other_desc
	FROM PowerMixer pa
	JOIN PowerTool pt ON pt.id = pa.id
	WHERE pt.id = var_toolid
	UNION
	SELECT
		CONCAT(
			COALESCE(dust_bag, ''), ' ',
			COALESCE(CONCAT(volt_rating, 'V'), ''), ' ',
			COALESCE(CONCAT(amp_rating, 'Amp'), ''), ' ',
			COALESCE(CONCAT(min_rpm_rating, 'min rpm'), ''), ' ',
			COALESCE(CONCAT(max_rpm_rating, 'max rpm'), '')
		) AS other_desc
	FROM PowerSander pa
	JOIN PowerTool pt ON pt.id = pa.id
	WHERE pt.id = var_toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(CONCAT(blade_size, 'in'), ''), ' ',
			COALESCE(CONCAT(volt_rating, 'V'), ''), ' ',
			COALESCE(CONCAT(amp_rating, 'Amp'), ''), ' ',
			COALESCE(CONCAT(min_rpm_rating, 'min rpm'), ''), ' ',
			COALESCE(CONCAT(max_rpm_rating, 'max rpm'), '')
		) AS other_desc
	FROM PowerSaw pa
	JOIN PowerTool pt ON pt.id = pa.id
	WHERE pt.id = var_toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(handle_material, ''), ' ',
			COALESCE(CONCAT(blade_length, 'in.'), ''), ' ',
			COALESCE(blade_material, '')
		) AS other_desc
	FROM PruningTool ga
	JOIN GardenTool gt ON gt.id = ga.id
	WHERE gt.id = var_toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(handle_material, ''), ' ',
			COALESCE(CONCAT(tine_count, 'tine'), ''), ' '
		) AS other_desc
	FROM RakeTool ga
	JOIN GardenTool gt ON gt.id = ga.id
	WHERE gt.id = var_toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(CONCAT(head_weight, 'lb.'), ''), ' ',
			COALESCE(handle_material, '')
		) AS other_desc
	FROM StrikingTool ga
	JOIN GardenTool gt ON gt.id = ga.id
	WHERE gt.id = var_toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(bin_material, ''), ' ',
			COALESCE(CONCAT(wheel_count, 'wheeled'), ''), ' ',
			COALESCE(CONCAT(bin_volume, 'cu ft.'), ''), ' ',
			COALESCE(handle_material, '')
		) AS other_desc
	FROM WheelBarrowTool ga
	JOIN GardenTool gt ON gt.id = ga.id
	WHERE gt.id = var_toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(CONCAT(blade_length, 'in.'), ''), ' ',
			COALESCE(CONCAT(blade_width, 'in.'), ''), ' ',
			COALESCE(handle_material, '')
		) AS other_desc
	FROM DiggingTool ga
	JOIN GardenTool gt ON gt.id = ga.id
	WHERE gt.id = var_toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(pail_shelf, ''), ' ',
			COALESCE(step_count, ''), ' ',
			COALESCE(CONCAT(weight_capacity, 'Lb.'), '')
		) AS other_desc
	FROM StepLadder la
	JOIN LadderTool lt ON lt.id = la.id
	WHERE la.id = var_toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(rubber_feet, ''), ' ',
			COALESCE(step_count, ''), ' ',
			COALESCE(CONCAT(weight_capacity, 'Lb.'), '')
		) AS other_desc
	FROM StraightLadder la
	JOIN LadderTool lt ON lt.id = la.id
	WHERE la.id = var_toolid
) other_desc
WHERE tool.id = var_toolid;
END$$
DELIMITER ;


