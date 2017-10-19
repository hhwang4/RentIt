-- Check Tool Availability

-- without keyword without details (full description, short)

set @powersource :='Manual';
set @subtype :='ScrewDriver';
set @category :='Hand';
set @startdate :='2017-10-02 00:00:00';
set @enddate :='2017-10-12 00:00:00';
set @saledate :='2017-10-02 00:00:00';
set @solddate :='2017-10-12 00:00:00';

SELECT 
	tool.id as toolId, 
    category.name as category, 
    powersource.name as powersource,
    subtype.name as subtype, suboption.name as suboption,
    rental_price, 
    deposit_price 
FROM Tool as tool
JOIN SubOption as suboption ON suboption.id = tool.SubOption_Id
JOIN SubType as subtype ON subtype.id = tool.SubType_Id
JOIN PowerSource as powersource ON powersource.id = tool.PowerSource_Id
JOIN Category as category ON category.id = tool.Category_Id
WHERE subtype.name = @subtype 
	AND powersource.name = @powersource 
    AND category.name = @category
    AND tool.id NOT IN (
		SELECT Tool_Id as toolId 
		from ToolReservations as toolreserv
		JOIN Reservation as reservation ON reservation.id = toolreserv.Reservations_Id
		WHERE reservation.start_date >= @startdate AND reservation.end_date <= @enddate
		)
	AND tool.id NOT IN (
		SELECT Tool_Id as toolId
        from SaleOrder as saleorder
        WHERE saleorder.for_sale_date >= @saledate AND saleorder.sold_date is NOT NULL AND saleorder.sold_date <= @solddate 
    )    
    AND tool.id NOT IN (
		SELECT Tool_Id as toolId 
		from ServiceOrder as serviceorder
		WHERE serviceorder.start_date >= @startdate AND serviceorder.end_date <= @enddate
		)

