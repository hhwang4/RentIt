-- tool check availability with tool details and without keyword search

set @powersource :='Manual';
set @subtype :='ScrewDriver';
set @category :='Hand';
set @startdate :='2017-10-02 00:00:00';
set @enddate :='2017-10-12 00:00:00';
set @saledate :='2017-10-02 00:00:00';
set @solddate :='2017-10-12 00:00:00';

SELECT 
	toolId,
    full_desc,
    short_desc,
    other_desc,
	powersource,
	subtype, 
    suboption,
	rental_price, 
	deposit_price,
	material,
	width,
	weight,
	length,
	manufacturer
FROM(
	SELECT 
		tool.id as toolId, 
		category.name as category, 
		CONCAT(
			COALESCE(IF(
					powersource.name='A/C','electric', 
					IF(
						powersource.name='D/C', 'cordless',
						IF(powersource.name = 'Manual', '',
						powersource.name)
					)
				), ''), ' ',
			COALESCE(suboption.name, ''), ' ', 
			COALESCE(subtype.name, '')
		) as short_desc,
		CONCAT(
			COALESCE(width, ''), ' in. W x ',
			COALESCE(length, ''), 'in. L ',
            CONCAT(COALESCE(weight, ''), 'lb'), ' ',
			COALESCE(other_desc.other_desc, ''), ' ',
			COALESCE(IF(
					powersource.name='A/C','electric', 
					IF(
						powersource.name='D/C', 'cordless',
						IF(powersource.name = 'Manual', '',
						powersource.name)
					)
				), ''), ' ',
			COALESCE(suboption.name, ''), ' ',
			COALESCE(subtype.name, ''), ' ',
			CONCAT('By ', COALESCE(manufacturer, '')), ' '
		) as full_desc,
        other_desc.other_desc,
		powersource.name as powersource,
		subtype.name as subtype, suboption.name as suboption,
		rental_price, 
		deposit_price,
		material,
		width,
		weight,
		length,
		manufacturer
	FROM Tool as tool
	JOIN SubOption as suboption ON suboption.id = tool.SubOption_Id
	JOIN SubType as subtype ON subtype.id = tool.SubType_Id
	JOIN PowerSource as powersource ON powersource.id = tool.PowerSource_Id
	JOIN Category as category ON category.id = tool.Category_Id
	JOIN (
		SELECT
			id AS toolId, 
			CONCAT(
				COALESCE(CONCAT(gauge_rating, 'G'), ''), ' ', 
				COALESCE(capacity, '')
			) AS other_desc
		FROM HandGun
		UNION
		SELECT
			id AS toolId, 
			anti_vibration AS other_desc
		FROM HandHammer	
		UNION
		SELECT
			id AS toolId, 
			adjustable AS other_desc
		FROM HandPlier
		UNION
		SELECT
			id AS toolId, 
			CONCAT(drive_size, 'in') AS other_desc
		FROM HandRatchet
		UNION
		SELECT
			id AS toolId, 
            CONCAT('#', screw_size) AS other_desc
		FROM ScrewDriver
		UNION
		SELECT
			id AS toolId, 
			CONCAT(
				COALESCE(CONCAT(drive_size, 'in'), ''), ' ', 
				COALESCE(CONCAT(sae_size, 'in'), ''), ' ', 
				COALESCE(deep_socket, '')
			) AS other_desc
		FROM HandSocket
		UNION
		SELECT
			pt.id AS toolId,         
			CONCAT(
				COALESCE(CONCAT(tank_size, 'gal.'), ''), ' ', 
				COALESCE(CONCAT(pressure_rating, 'psi'), ''), ' ',
				COALESCE(CONCAT(volt_rating, 'V'), ''), ' ',
				COALESCE(CONCAT(amp_rating, 'Amp'), ''), ' ',
				COALESCE(CONCAT(min_rpm_rating, 'min rpm'), ''), ' ',
				COALESCE(CONCAT(max_rpm_rating, 'max rpm'), '')
			) AS other_desc
		FROM PowerAirCompressor pa 
		JOIN PowerTool pt ON pt.id = pa.id
		UNION
		SELECT
			pt.id as toolId,
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
		UNION
		SELECT
			pt.id as toolId,
            CONCAT(
				COALESCE(CONCAT(power_rating, 'Watts'), ''), ' ',
				COALESCE(CONCAT(volt_rating, 'V'), ''), ' ',
				COALESCE(CONCAT(amp_rating, 'Amp'), ''), ' ',
				COALESCE(CONCAT(min_rpm_rating, 'min rpm'), ''), ' ',
				COALESCE(CONCAT(max_rpm_rating, 'max rpm'), '')
			) AS other_desc
		FROM PowerGenerator pa 
		JOIN PowerTool pt ON pt.id = pa.id
		UNION
		SELECT
			pt.id as toolId,
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
		UNION
		SELECT
			pt.id as toolId,
            CONCAT(
				COALESCE(dust_bag, ''), ' ',
				COALESCE(CONCAT(volt_rating, 'V'), ''), ' ',
				COALESCE(CONCAT(amp_rating, 'Amp'), ''), ' ',
				COALESCE(CONCAT(min_rpm_rating, 'min rpm'), ''), ' ',
				COALESCE(CONCAT(max_rpm_rating, 'max rpm'), '')
			) AS other_desc
		FROM PowerSander pa 
		JOIN PowerTool pt ON pt.id = pa.id
		UNION
		SELECT
			pt.id as toolId,
			CONCAT(
				COALESCE(CONCAT(blade_size, 'in.'), ''), ' ', 
				COALESCE(CONCAT(volt_rating, 'V'), ''), ' ',
				COALESCE(CONCAT(amp_rating, 'Amp'), ''), ' ',
				COALESCE(CONCAT(min_rpm_rating, 'min rpm'), ''), ' ',
				COALESCE(CONCAT(max_rpm_rating, 'max rpm'), '')
			) AS other_desc
		FROM PowerSaw pa 
		JOIN PowerTool pt ON pt.id = pa.id
		UNION
		SELECT
			ga.id as toolId,
			CONCAT(
				COALESCE(handle_material, ''), ' ',
				COALESCE(CONCAT(blade_length, 'in.'), ''), ' ',
				COALESCE(blade_material, '')
			) AS other_desc
		FROM PruningTool ga 
		JOIN GardenTool gt ON gt.id = ga.id
		UNION
		SELECT
			ga.id as toolId,
            CONCAT(
				COALESCE(handle_material, ''), ' ',
				COALESCE(CONCAT(tine_count, 'tine'), ''), ' '
			) AS other_desc
		FROM RakeTool ga 
		JOIN GardenTool gt ON gt.id = ga.id
		UNION
		SELECT
			ga.id as toolId,
			CONCAT(
				COALESCE(CONCAT(head_weight, 'lb.'), ''), ' ',
				COALESCE(handle_material, '')
			) AS other_desc
		FROM StrikingTool ga 
		JOIN GardenTool gt ON gt.id = ga.id
		UNION
		SELECT
			ga.id as toolId,
			CONCAT(
				COALESCE(bin_material, ''), ' ',
				COALESCE(CONCAT(wheel_count, 'wheeled'), ''), ' ',
				COALESCE(CONCAT(bin_volume, 'cu ft.'), ''), ' ',
				COALESCE(handle_material, '')
			) AS other_desc
		FROM WheelBarrowTool ga 
		JOIN GardenTool gt ON gt.id = ga.id
		UNION
		SELECT
			ga.id as toolId,
			CONCAT(
				COALESCE(CONCAT(blade_length, 'in.'), ''), ' ',
				COALESCE(CONCAT(blade_width, 'in.'), ''), ' ',
				COALESCE(handle_material, '')
			) AS other_desc
		FROM DiggingTool ga 
		JOIN GardenTool gt ON gt.id = ga.id
		UNION
		SELECT
			la.id as toolId,
			CONCAT(
				COALESCE(pail_shelf, ''), ' ',
				COALESCE(step_count, ''), ' ', 
				COALESCE(CONCAT(weight_capacity, 'Lb.'), '')
			) AS other_desc
		FROM StepLadder la 
		JOIN LadderTool lt ON lt.id = la.id
		UNION
		SELECT
			la.id as toolId,
            CONCAT(
				COALESCE(rubber_feet, ''), ' ',
				COALESCE(step_count, ''), ' ', 
				COALESCE(CONCAT(weight_capacity, 'Lb.'), '')
			) AS other_desc
		FROM StraightLadder la 
		JOIN LadderTool lt ON lt.id = la.id
	) other_desc
	ON other_desc.toolId = tool.id
) tools
WHERE 
	subtype = @subtype 
	AND powersource = @powersource 
    AND category = @category
    AND toolId NOT IN (
		SELECT Tool_Id as toolId 
		from ToolReservations as toolreserv
		JOIN Reservation as reservation ON reservation.id = toolreserv.Reservations_Id
		WHERE reservation.start_date >= @startdate AND reservation.end_date <= @enddate
	)
	AND toolId NOT IN (
		SELECT Tool_Id as toolId
        from SaleOrder as saleorder
        WHERE saleorder.for_sale_date >= @saledate AND saleorder.sold_date is NOT NULL AND saleorder.sold_date <= @solddate 
    )    
    AND toolId NOT IN (
		SELECT Tool_Id as toolId 
		from ServiceOrder as serviceorder
		WHERE serviceorder.start_date >= @startdate AND serviceorder.end_date <= @enddate
	)