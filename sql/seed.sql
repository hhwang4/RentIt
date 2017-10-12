use cs6400_fa17_team033;

SELECT last_insert_id();

# Clerk Users
insert into Clerk values('admin@gatech.edu','2015-12-01', 'password', 1, 'The', 'Best', 'Admin', 'admin@gatech.edu', 'hunter2');

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
