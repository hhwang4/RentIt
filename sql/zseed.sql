use cs6400_sfa17_team033;

# Clerk Users
insert into Clerk (user_name, date_of_hire,temp_password, first_name, middle_name, last_name, email, password)
values('admin@gatech.edu','2015-12-01', 'password', 'The', 'Best', 'Admin', 'admin@gatech.edu', 'hunter2');

# Customers
insert into Address (street, city, state, zip) values('123 main street', 'Gotham City', 'NY', '55555-5555');

set @addressId := last_insert_id();

insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) values('Bruce Wayne', '0000-5555-5555-0232', '004', 2, 2020);

set @creditCardId := last_insert_id();

insert into PhoneNumber (area_code, number, extension) values('321', '867-5309', NULL);

set @phoneId := last_insert_id();

insert into Customer (user_name, primary_phone, first_name,middle_name,last_name,email,password,Address_Id, CellPhoneNumber_Id, CreditCard_Id,HomePhoneNumber_Id,WorkPhoneNumber_Id)
values('thebatman', 1, 'Bruce', 'Tyrone', 'Wayne', 'thebatman@aol.com', 'robin', @addressId, NULL, @creditCardId, NULL, @phoneId);


# Category and subtypes

insert into Category (name) VALUES ('Hand');
set @handCategoryId := last_insert_id();

insert into Category (name) VALUES ('Garden');
set @gardenCategoryId := last_insert_id();

insert into Category (name) VALUES ('Ladder');
set @ladderCategoryId := last_insert_id();

insert into Category (name) VALUES ('Power');
set @powerCategoryId := last_insert_id();

#Power sources
insert into PowerSource (name) VALUES ('Manual');
set @manualPowerSourceId := last_insert_id();

insert into PowerSource (name) VALUES ('A/C');
set @acPowerSourceId := last_insert_id();

insert into PowerSource (name) VALUES ('D/C');
set @dcPowerSourceId := last_insert_id();

insert into PowerSource (name) VALUES ('Gas');
set @gasPowerSourceId := last_insert_id();


# Power Source Category relationship
insert into PowerSourceCategory (PowerSource_Id, Category_Id) VALUES (@manualPowerSourceId, @handCategoryId);
insert into PowerSourceCategory (PowerSource_Id, Category_Id) VALUES (@manualPowerSourceId, @gardenCategoryId);
insert into PowerSourceCategory (PowerSource_Id, Category_Id) VALUES (@manualPowerSourceId, @ladderCategoryId);

insert into PowerSourceCategory (PowerSource_Id, Category_Id) VALUES (@acPowerSourceId, @powerCategoryId);
insert into PowerSourceCategory (PowerSource_Id, Category_Id) VALUES (@dcPowerSourceId, @powerCategoryId);
insert into PowerSourceCategory (PowerSource_Id, Category_Id) VALUES (@gasPowerSourceId, @powerCategoryId);


# Sub Types Hand
insert into SubType (name) VALUES ('Screwdriver');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('phillips (cross)', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('hex', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('torx', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('slotted (flat)', @lastSubtype);


insert into SubType (name) VALUES ('Socket');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('deep', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('standard', @lastSubtype);

insert into SubType (name) VALUES ('Ratchet');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('adjustable', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('fixed', @lastSubtype);

insert into SubType (name) VALUES ('Wrench');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('crescent', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('torque', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('pipe', @lastSubtype);


insert into SubType (name) VALUES ('Pliers');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('needle nose', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('cutting', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('crimper', @lastSubtype);


insert into SubType (name) VALUES ('Gun');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('nail', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('staple', @lastSubtype);

insert into SubType (name) VALUES ('Hammer');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('claw', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('sledge', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('framing', @lastSubtype);


# Garden Subtypes

insert into SubType (name) VALUES ('Digger');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('pointed shovel', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('flat shovel', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('scoop shovel', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('edger', @lastSubtype);


insert into SubType (name) VALUES ('Pruner');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('sheer', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('loppers', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('hedge', @lastSubtype);

insert into SubType (name) VALUES ('Rakes');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('leaf', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('landscaping', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('rock', @lastSubtype);

insert into SubType (name) VALUES ('Wheelbarrows');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('1-wheel', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('2-wheel', @lastSubtype);

insert into SubType (name) VALUES ('Striking');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('bar pry', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('rubber mallet', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('tamper', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('pick axe', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('single bit axe', @lastSubtype);


# Ladder
insert into SubType (name) VALUES ('Straight');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('rigid', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('telescoping', @lastSubtype);

insert into SubType (name) VALUES ('Step');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('folding', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('multi-position', @lastSubtype);


# Power

insert into SubType (name) VALUES ('Drill');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('driver', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('hammer', @lastSubtype);

insert into SubType (name) VALUES ('Saw');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('circular', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('reciprocating', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('jig', @lastSubtype);

insert into SubType (name) VALUES ('Sander');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('finish', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('sheet', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('belt', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('random orbital', @lastSubtype);

insert into SubType (name) VALUES ('Air-Compressor');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('reciprocating', @lastSubtype);

insert into SubType (name) VALUES ('Mixer');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('concrete', @lastSubtype);

insert into SubType (name) VALUES ('Generator');
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('electric', @lastSubtype);


# setup powersource subtype relationship

insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Screwdriver'), @manualPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Socket'), @manualPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Ratchet'), @manualPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Wrench'), @manualPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Pliers'), @manualPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Gun'), @manualPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Hammer'), @manualPowerSourceId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Digger'), @manualPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Pruner'), @manualPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Rakes'), @manualPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Wheelbarrows'), @manualPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Striking'), @manualPowerSourceId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Straight'), @manualPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Step'), @manualPowerSourceId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Drill'), @acPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Drill'), @dcPowerSourceId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Saw'), @acPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Saw'), @dcPowerSourceId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Sander'), @acPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Sander'), @dcPowerSourceId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Air-Compressor'), @acPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Air-Compressor'), @gasPowerSourceId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Mixer'), @acPowerSourceId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Mixer'), @gasPowerSourceId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id) VALUES ((select id from SubType where name = 'Generator'), @gasPowerSourceId);

# Insert Hand Tools
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (2.0, 2.25, 6, 'Dewalt', 'steel', 15.60, 5.33, @handCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Screwdriver'), (select id from SubOption where name = 'hex'));

set @lastTool:= last_insert_id();
insert into HandTool VALUES (@lastTool);
set @lastTool:= last_insert_id();
insert into ScrewDriver (id, screw_size) VALUES (@lastTool, 4);

insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (2.0, 2.25, 6, 'Dewalt', 'steel', 15.60, 5.33, @handCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Screwdriver'), (select id from SubOption where name = 'hex'));

set @lastTool:= last_insert_id();
insert into HandTool VALUES (@lastTool);
set @lastTool:= last_insert_id();
insert into ScrewDriver (id, screw_size) VALUES (@lastTool, 4);

insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (12.0, 5.25, 68, 'Dewalt', 'plastic', 0.60, 12.44, @handCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Screwdriver'), (select id from SubOption where name = 'hex'));

set @lastTool:= last_insert_id();
insert into HandTool VALUES (@lastTool);
set @lastTool:= last_insert_id();
insert into ScrewDriver (id, screw_size) VALUES (@lastTool, 7);


#Hand socket
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (2.0, 2.25, 6, 'Dewalt', 'steel', 15.60, 5.33, @handCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Socket'), (select id from SubOption where name = 'deep'));

set @lastTool:= last_insert_id();
insert into HandTool VALUES (@lastTool);
set @lastTool:= last_insert_id();
insert into HandSocket (id, drive_size, sae_size, deep_socket) VALUES (@lastTool, .5, .25, true);

# Hand Ratchet
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (2.0, 2.25, 6, 'Dewalt', 'steel', 15.60, 5.33, @handCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Ratchet'), (select id from SubOption where name = 'fixed'));

set @lastTool:= last_insert_id();
insert into HandTool VALUES (@lastTool);
set @lastTool:= last_insert_id();
insert into HandRatchet (id, drive_size) VALUES (@lastTool, .5);


# Garden tools insert
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (2.0, 2.25, 6, 'Dewalt', 'steel', 15.60, 5.33, @gardenCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Digger'), (select id from SubOption where name = 'edger'));

set @lastTool:= last_insert_id();
insert into GardenTool (id, handle_material) VALUES (@lastTool, 'wood');
set @lastTool:= last_insert_id();
insert into DiggingTool (id, blade_width, blade_length) VALUES (@lastTool, NULL, .25);

# Ladder Tools Insert
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (2.0, 2.25, 6, 'Dewalt', 'steel', 15.60, 5.33, @ladderCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Step'), (select id from SubOption where name = 'folding'));

set @lastTool:= last_insert_id();
insert into LadderTool (id, step_count, weight_capacity) VALUES (@lastTool, 10, 6.3);
set @lastTool:= last_insert_id();
insert into StepLadder (id, pail_shelf) VALUES (@lastTool, true);

# Power Tool insert
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (22.0, 2.25, 6, 'Dewalt', 'steel', 14, 88.98, @powerCategoryId, @dcPowerSourceId, (select id from SubType where name = 'Drill'), (select id from SubOption where name = 'hammer'));

set @lastTool:= last_insert_id();
insert into PowerTool (id, volt_rating, amp_rating, min_rpm_rating, max_rpm_rating) VALUES (@lastTool, 110, 30, 2000, 4500);
set @lastTool:= last_insert_id();
insert into PowerDrill (id, adjustable_clutch, min_torque_rating, max_torque_rating) VALUES (@lastTool, true, 80.5, NULL);


#Power tool accessory
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Drill Bits', 6, @lastTool);


# Reservations
insert into Reservation (booking_date, start_date, end_date, Customer_UserName, DropOffClerk_UserName, PickupClerk_UserName)
VALUES (NOW(), '2017-10-02', '2017-10-12', 'thebatman', NULL, NULL);

# Sale Order
insert into SaleOrder (for_sale_date, sold_date, purchase_price, Customer_UserName, Tool_Id)
VALUES ('2017-10-02', '2017-10-09', 47.88, 'thebatman', 1);

# Service Order
insert into ServiceOrder (start_date, end_date, service_cost, Tool_Id)
VALUES ('2017-10-02', '2017-10-09', 47.88, 1);
