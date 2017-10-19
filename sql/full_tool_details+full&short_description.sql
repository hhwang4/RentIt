-- Full Tool Details

-- including all the details of full description and short description

set @toolid :='8';
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
JOIN Accessory as accessory ON accessory.PowerTool_Id = tool.id
JOIN (

	SELECT
		CONCAT(
			COALESCE(CONCAT(gauge_rating, 'G'), ''), ' ', 
			COALESCE(capacity, '')
		) AS other_desc
	FROM HandGun
	WHERE id = @toolid
	UNION
	SELECT
		anti_vibration AS other_desc
	FROM HandHammer	
	WHERE id = @toolid
	UNION
	SELECT
		adjustable AS other_desc
	FROM HandPlier
	WHERE id = @toolid
	UNION
	SELECT
		CONCAT(drive_size, 'in') AS other_desc
	FROM HandRatchet
	WHERE id = @toolid
	UNION
	SELECT
		CONCAT('#', screw_size)AS other_desc
	FROM ScrewDriver
	WHERE id = @toolid
	UNION
	SELECT
		CONCAT(
			COALESCE(CONCAT(drive_size, 'in'), ''), ' ', 
			COALESCE(CONCAT(sae_size, 'in'), ''), ' ',
			COALESCE(deep_socket, '')
		) AS other_desc
	FROM HandSocket
	WHERE id = @toolid
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
	WHERE pt.id = @toolid
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
	WHERE pt.id = @toolid
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
	WHERE pt.id = @toolid
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
	WHERE pt.id = @toolid
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
	WHERE pt.id = @toolid

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
	WHERE pt.id = @toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(handle_material, ''), ' ',
			COALESCE(CONCAT(blade_length, 'in.'), ''), ' ',
			COALESCE(blade_material, '')
		) AS other_desc
	FROM PruningTool ga 
	JOIN GardenTool gt ON gt.id = ga.id
	WHERE gt.id = @toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(handle_material, ''), ' ',
			COALESCE(CONCAT(tine_count, 'tine'), ''), ' '
		) AS other_desc
	FROM RakeTool ga 
	JOIN GardenTool gt ON gt.id = ga.id
	WHERE gt.id = @toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(CONCAT(head_weight, 'lb.'), ''), ' ',
			COALESCE(handle_material, '')
		) AS other_desc
	FROM StrikingTool ga 
	JOIN GardenTool gt ON gt.id = ga.id
	WHERE gt.id = @toolid

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
	WHERE gt.id = @toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(CONCAT(blade_length, 'in.'), ''), ' ',
			COALESCE(CONCAT(blade_width, 'in.'), ''), ' ',
			COALESCE(handle_material, '')
		) AS other_desc
	FROM DiggingTool ga 
	JOIN GardenTool gt ON gt.id = ga.id
	WHERE gt.id = @toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(pail_shelf, ''), ' ',
			COALESCE(step_count, ''), ' ', 
			COALESCE(CONCAT(weight_capacity, 'Lb.'), '')
		) AS other_desc
	FROM StepLadder la 
	JOIN LadderTool lt ON lt.id = la.id
	WHERE la.id = @toolid

	UNION
	SELECT
		CONCAT(
			COALESCE(rubber_feet, ''), ' ',
			COALESCE(step_count, ''), ' ', 
			COALESCE(CONCAT(weight_capacity, 'Lb.'), '')
		) AS other_desc
	FROM StraightLadder la 
	JOIN LadderTool lt ON lt.id = la.id
	WHERE la.id = @toolid
) other_desc
WHERE tool.id = @toolid;

