use cs6400_sfa17_team033;

# Clerk Users
#clerk:1
insert into Clerk (user_name, date_of_hire,temp_password, first_name, middle_name, last_name, email, password)
values('admin@gatech.edu','2015-12-01', 'password', 'The', 'Best', 'Admin', 'admin@gatech.edu', 'hunter2');
#clerk:2
insert into Clerk (user_name, date_of_hire,temp_password, first_name, middle_name, last_name, email, password)
values('admin1@gatech.edu','2015-01-01', 'password', 'The', 'Best', 'Admin1', 'admin1@gatech.edu', 'hunter2');
#clerk:3
insert into Clerk (user_name, date_of_hire,temp_password, first_name, middle_name, last_name, email, password)
values('admin2@gatech.edu','2015-05-01', 'password', 'The', 'Best', 'Admin2', 'admin2@gatech.edu', 'hunter2');
#clerk:4
insert into Clerk (user_name, date_of_hire,temp_password, first_name, middle_name, last_name, email, password)
values('admin3@gatech.edu','2017-02-01', 'password', 'The', 'Best', 'Admin3', 'admin3@gatech.edu', 'hunter2');
#clerk:5
insert into Clerk (user_name, date_of_hire,temp_password, first_name, middle_name, last_name, email, password)
values('admin4@gatech.edu','2017-08-01', 'password', 'The', 'Best', 'Admin4', 'admin4@gatech.edu', 'hunter2');
#clerk:6
insert into Clerk (user_name, date_of_hire,temp_password, first_name, middle_name, last_name, email, password)
values('admin5@gatech.edu','2010-12-01', 'password', 'The', 'Best', 'Admin5', 'admin5@gatech.edu', 'hunter2');
#clerk:7
insert into Clerk (user_name, date_of_hire,temp_password, first_name, middle_name, last_name, email, password)
values('admin6@gatech.edu','2010-09-01', 'password', 'The', 'Best', 'Admin6', 'admin6@gatech.edu', 'hunter2');
#clerk:8
insert into Clerk (user_name, date_of_hire,temp_password, first_name, middle_name, last_name, email, password)
values('admin7@gatech.edu','2014-05-01', 'password', 'The', 'Best', 'Admin7', 'admin7@gatech.edu', 'hunter2');
#clerk:9
insert into Clerk (user_name, date_of_hire,temp_password, first_name, middle_name, last_name, email, password)
values('admin8@gatech.edu','2011-12-01', 'password', 'The', 'Best', 'Admin8', 'admin8@gatech.edu', 'hunter2');
#clerk:10
insert into Clerk (user_name, date_of_hire,temp_password, first_name, middle_name, last_name, email, password)
values('admin9@gatech.edu','2012-12-01', 'password', 'The', 'Best', 'Admin9', 'admin9@gatech.edu', 'hunter2');

# Customers

#customer:1
insert into Address (street, city, state, zip) values('123 main street', 'Gotham City', 'NY', '55555-5555');

set @addressId := last_insert_id();

insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) values('Bruce Wayne', '0000-5555-5555-0232', '004', 2, 2020);

set @creditCardId := last_insert_id();

insert into Customer (user_name, first_name,middle_name,last_name,email,password,Address_Id, CreditCard_Id)
values('thebatman', 'Bruce', 'Tyrone', 'Wayne', 'thebatman@aol.com', 'robin', @addressId, @creditCardId);

insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '867-5309', NULL, 'cell', TRUE, 'thebatman');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '867-5308', NULL, 'work', False, 'thebatman');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('444', '867-5308', NULL, 'home', False, 'thebatman');

#customer:2
insert into Address (street, city, state, zip) values('77 weekly street', 'Diablo City', 'UT', '6666-5555');
set @addressId1 := last_insert_id();

insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) values('Bryan Fernando', '0000-6666-5555-0232', '005', 2, 2022);
set @creditCardId1 := last_insert_id();

insert into Customer (user_name, first_name,middle_name,last_name,email,password,Address_Id, CreditCard_Id)
values('thehulk', 'Bryan', 'Wilson', 'Fernando', 'thehulk@gmail.com', 'user123', @addressId1, @creditCardId1);

insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '867-5307', NULL, 'cell', TRUE, 'thehulk');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '867-5309', NULL, 'work', False, 'thehulk');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('444', '867-5303', NULL, 'home', False, 'thehulk');

#customer:3
insert into Address (street, city, state, zip) values('7 bellevue way', 'Bellevue City', 'WA', '9999-0008');
set @addressId1 := last_insert_id();

insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) values('Robert Mayer', '0000-7777-5555-0232', '006', 2, 2024);
set @creditCardId1 := last_insert_id();

insert into Customer (user_name, first_name,middle_name,last_name,email,password,Address_Id, CreditCard_Id)
values('thor', 'Robert', 'W.', 'Mayer', 'thor@gmail.com', 'user123', @addressId1, @creditCardId1);

insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '867-5317', NULL, 'cell', TRUE, 'thor');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '867-5319', NULL, 'work', False, 'thor');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('444', '867-5313', NULL, 'home', False, 'thor');

#customer:4
insert into Address (street, city, state, zip) values('55 weekly street', 'Bambo City', 'UT', '6666-8888');
set @addressId1 := last_insert_id();

insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) values('Andrei Sebastian', '0000-8888-5555-0232', '005', 2, 2023);
set @creditCardId1 := last_insert_id();

insert into Customer (user_name, first_name,middle_name,last_name,email,password,Address_Id, CreditCard_Id)
values('andreiseb', 'Andrei', 'X.', 'Sebastian', 'andreiseb@gmail.com', 'user123', @addressId1, @creditCardId1);

insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '867-7777', NULL, 'cell', TRUE, 'andreiseb');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '867-4444', NULL, 'work', False, 'andreiseb');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('444', '867-3333', NULL, 'home', False, 'andreiseb');

#customer:5
insert into Address (street, city, state, zip) values('7 Redmond way', 'Redmond City', 'WA', '9999-0024');
set @addressId1 := last_insert_id();

insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) values('Dan Rob', '0000-7777-7272-0232', '012', 2, 2021);
set @creditCardId1 := last_insert_id();

insert into Customer (user_name, first_name,middle_name,last_name,email,password,Address_Id, CreditCard_Id)
values('dan1', 'Dan', 'M.', 'Rob', 'dan1@gmail.com', 'user123', @addressId1, @creditCardId1);

insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '323-5317', NULL, 'cell', FALSE, 'dan1');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '323-5319', NULL, 'work', False, 'dan1');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('444', '323-5313', NULL, 'home', TRUE, 'dan1');


#customer:6
insert into Address (street, city, state, zip) values('7 massac street', 'Bothel City', 'WA', '6666-5555');
set @addressId1 := last_insert_id();

insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) values('Bryan Fernando', '0000-3676-5555-0232', '015', 2, 2022);
set @creditCardId1 := last_insert_id();

insert into Customer (user_name, first_name,middle_name,last_name,email,password,Address_Id, CreditCard_Id)
values('max9', 'Max', 'Wilson', 'Zor', 'max9@gmail.com', 'user123', @addressId1, @creditCardId1);

insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '223-5307', NULL, 'cell', TRUE, 'max9');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '223-5309', NULL, 'work', False, 'max9');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('444', '223-5303', NULL, 'home', False, 'max9');

#customer:7
insert into Address (street, city, state, zip) values('7 renton way', 'Renton City', 'WA', '9999-0208');
set @addressId1 := last_insert_id();

insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) values('Rassel Wilson', '0000-4433-5555-0232', '077', 2, 2024);
set @creditCardId1 := last_insert_id();

insert into Customer (user_name, first_name,middle_name,last_name,email,password,Address_Id, CreditCard_Id)
values('rasselw', 'Rassel', 'B.', 'Wilson', 'rasselw@outlook.com', 'user123', @addressId1, @creditCardId1);

insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '867-7373', NULL, 'cell', TRUE, 'rasselw');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '867-7733', NULL, 'work', False, 'rasselw');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('444', '867-7772', NULL, 'home', False, 'rasselw');

#customer:8
insert into Address (street, city, state, zip) values('55 Lamburd street', 'San Fransisco City', 'CA', '7383-8888');
set @addressId1 := last_insert_id();

insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) values('Christiano Ronaldo', '0000-2727-5555-0232', '033', 2, 2023);
set @creditCardId1 := last_insert_id();

insert into Customer (user_name, first_name,middle_name,last_name,email,password,Address_Id, CreditCard_Id)
values('christronald', 'Christiano', 'X.', 'Ronaldo', 'christronald@gmail.com', 'user123', @addressId1, @creditCardId1);

insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '666-7767', NULL, 'cell', TRUE, 'christronald');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '666-4464', NULL, 'work', False, 'christronald');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('444', '666-3363', NULL, 'home', False, 'christronald');

#customer:9
insert into Address (street, city, state, zip) values('7 Minor street', 'Seattle City', 'WA', '9999-2323');
set @addressId1 := last_insert_id();

insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) values('Van Goh', '3333-7777-7272-0232', '012', 2, 2019);
set @creditCardId1 := last_insert_id();

insert into Customer (user_name, first_name,middle_name,last_name,email,password,Address_Id, CreditCard_Id)
values('vangoh', 'Van', 'M.', 'Goh', 'vangoh@gmail.com', 'user123', @addressId1, @creditCardId1);

insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '323-5317', NULL, 'cell', TRUE, 'vangoh');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '323-5319', NULL, 'work', False, 'vangoh');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('444', '323-5313', NULL, 'home', False, 'vangoh');

#customer:10
insert into Address (street, city, state, zip) values('7 Union street', 'New York City', 'NY', '9899-0111');
set @addressId1 := last_insert_id();

insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) values('Mark Vand', '2828-7777-7272-0232', '018', 4, 2019);
set @creditCardId1 := last_insert_id();

insert into Customer (user_name, first_name,middle_name,last_name,email,password,Address_Id, CreditCard_Id)
values('markoo', 'Mark', 'B.', 'Vand', 'markoo@gmail.com', 'user123', @addressId1, @creditCardId1);

insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '323-5317', NULL, 'cell', TRUE, 'markoo');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '323-5319', NULL, 'work', False, 'markoo');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('444', '323-5313', NULL, 'home', False, 'markoo');

#customer:11
insert into Address (street, city, state, zip) values('7 Beach street', 'Honololou City', 'HW', '3434-0033');
set @addressId1 := last_insert_id();

insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) values('Van Goh', '3334-7777-4432-0232', '314', 2, 2019);
set @creditCardId1 := last_insert_id();

insert into Customer (user_name, first_name,middle_name,last_name,email,password,Address_Id, CreditCard_Id)
values('winne', 'Winne', 'the', 'Pooh', 'winne@gmail.com', 'user123', @addressId1, @creditCardId1);

insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '444-4343', NULL, 'cell', TRUE, 'winne');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('321', '444-3434', NULL, 'work', False, 'winne');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('444', '444-5553', NULL, 'home', False, 'winne');

#customer:12
insert into Address (street, city, state, zip) values('7 Union street', 'Tennisse City', 'WI', '3424-0111');
set @addressId1 := last_insert_id();

insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) values('Mark Vand', '2828-3883-7272-9393', '241', 4, 2020);
set @creditCardId1 := last_insert_id();

insert into Customer (user_name, first_name,middle_name,last_name,email,password,Address_Id, CreditCard_Id)
values('williamshk', 'William', 'B.', 'Shekspear', 'williamshk@gmail.com', 'user123', @addressId1, @creditCardId1);

insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('232', '323-9339', NULL, 'cell', TRUE, 'williamshk');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('232', '323-3319', NULL, 'work', False, 'williamshk');
insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values('232', '323-4413', NULL, 'home', False, 'williamshk');

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
insert into SubType (name, Category_Id) VALUES ('Screwdriver', @handCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('phillips (cross)', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('hex', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('torx', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('slotted (flat)', @lastSubtype);


insert into SubType (name, Category_Id) VALUES ('Socket', @handCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('deep', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('standard', @lastSubtype);

insert into SubType (name, Category_Id) VALUES ('Ratchet', @handCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('adjustable', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('fixed', @lastSubtype);

insert into SubType (name, Category_Id) VALUES ('Wrench', @handCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('crescent', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('torque', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('pipe', @lastSubtype);


insert into SubType (name, Category_Id) VALUES ('Pliers', @handCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('needle nose', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('cutting', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('crimper', @lastSubtype);


insert into SubType (name, Category_Id) VALUES ('Gun', @handCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('nail', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('staple', @lastSubtype);

insert into SubType (name, Category_Id) VALUES ('Hammer', @handCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('claw', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('sledge', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('framing', @lastSubtype);


# Garden Subtypes

insert into SubType (name, Category_Id) VALUES ('Digger', @gardenCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('pointed shovel', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('flat shovel', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('scoop shovel', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('edger', @lastSubtype);


insert into SubType (name, Category_Id) VALUES ('Pruner', @gardenCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('sheer', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('loppers', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('hedge', @lastSubtype);

insert into SubType (name, Category_Id) VALUES ('Rakes', @gardenCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('leaf', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('landscaping', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('rock', @lastSubtype);

insert into SubType (name, Category_Id) VALUES ('Wheelbarrows', @gardenCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('1-wheel', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('2-wheel', @lastSubtype);

insert into SubType (name, Category_Id) VALUES ('Striking', @gardenCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('bar pry', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('rubber mallet', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('tamper', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('pick axe', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('single bit axe', @lastSubtype);


# Ladder
insert into SubType (name, Category_Id) VALUES ('Straight', @ladderCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('rigid', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('telescoping', @lastSubtype);

insert into SubType (name, Category_Id) VALUES ('Step', @ladderCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('folding', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('multi-position', @lastSubtype);


# Power

insert into SubType (name, Category_Id) VALUES ('Drill', @powerCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('driver', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('hammer', @lastSubtype);

insert into SubType (name, Category_Id) VALUES ('Saw', @powerCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('circular', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('reciprocating', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('jig', @lastSubtype);

insert into SubType (name, Category_Id) VALUES ('Sander', @powerCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('finish', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('sheet', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('belt', @lastSubtype);
insert into SubOption (name, SubType_Id) VALUES ('random orbital', @lastSubtype);

insert into SubType (name, Category_Id) VALUES ('Air-Compressor', @powerCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('reciprocating', @lastSubtype);

insert into SubType (name, Category_Id) VALUES ('Mixer', @powerCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('concrete', @lastSubtype);

insert into SubType (name, Category_Id) VALUES ('Generator', @powerCategoryId);
set @lastSubtype := last_insert_id();

insert into SubOption (name, SubType_Id) VALUES ('electric', @lastSubtype);


# setup powersource subtype relationship

insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Screwdriver'), @manualPowerSourceId, @handCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Socket'), @manualPowerSourceId, @handCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Ratchet'), @manualPowerSourceId, @handCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Wrench'), @manualPowerSourceId, @handCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Pliers'), @manualPowerSourceId, @handCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Gun'), @manualPowerSourceId, @handCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Hammer'), @manualPowerSourceId, @handCategoryId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Digger'), @manualPowerSourceId, @gardenCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Pruner'), @manualPowerSourceId, @gardenCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Rakes'), @manualPowerSourceId, @gardenCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Wheelbarrows'), @manualPowerSourceId, @gardenCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Striking'), @manualPowerSourceId, @gardenCategoryId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Straight'), @manualPowerSourceId, @ladderCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Step'), @manualPowerSourceId, @ladderCategoryId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Drill'), @acPowerSourceId, @powerCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Drill'), @dcPowerSourceId, @powerCategoryId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Saw'), @acPowerSourceId, @powerCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Saw'), @dcPowerSourceId, @powerCategoryId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Sander'), @acPowerSourceId, @powerCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Sander'), @dcPowerSourceId, @powerCategoryId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Air-Compressor'), @acPowerSourceId, @powerCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Air-Compressor'), @gasPowerSourceId, @powerCategoryId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Mixer'), @acPowerSourceId, @powerCategoryId);
insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Mixer'), @gasPowerSourceId, @powerCategoryId);

insert into SubTypePowerSource (SubType_Id, PowerSource_Id, Category_Id) VALUES ((select id from SubType where name = 'Generator'), @gasPowerSourceId, @powerCategoryId);

# Insert Hand Tools
#Hand tool : 1
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (2.0, 2.25, 6, 'Dewalt', 'steel', 15.60, 5.33, 44.0, @handCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Screwdriver'), (select id from SubOption where name = 'hex'));

set @lastTool:= last_insert_id();
insert into HandTool VALUES (@lastTool);
set @lastTool:= last_insert_id();
insert into ScrewDriver (id, screw_size) VALUES (@lastTool, 4);

#Hand tool : 2
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (2.0, 2.25, 6, 'Dewalt', 'steel', 15.60, 5.33, 55, @handCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Screwdriver'), (select id from SubOption where name = 'hex'));

set @lastTool:= last_insert_id();
insert into HandTool VALUES (@lastTool);
set @lastTool:= last_insert_id();
insert into ScrewDriver (id, screw_size) VALUES (@lastTool, 4);


#Hand tool : 3
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (12.0, 5.25, 68, 'Dewalt', 'plastic', 0.60, 12.44,99, @handCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Screwdriver'), (select id from SubOption where name = 'hex'));

set @lastTool:= last_insert_id();
insert into HandTool VALUES (@lastTool);
set @lastTool:= last_insert_id();
insert into ScrewDriver (id, screw_size) VALUES (@lastTool, 7);


#Hand socket

#Hand tool : 4
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (2.0, 2.25, 6, 'Dewalt', 'steel', 15.60, 5.33, 3, @handCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Socket'), (select id from SubOption where name = 'deep'));

set @lastTool:= last_insert_id();
insert into HandTool VALUES (@lastTool);
set @lastTool:= last_insert_id();
insert into HandSocket (id, drive_size, sae_size, deep_socket) VALUES (@lastTool, .5, .25, true);


#Hand tool : 5
# Hand Ratchet
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (2.0, 2.25, 6, 'Dewalt', 'steel', 15.60, 5.33, 7, @handCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Ratchet'), (select id from SubOption where name = 'fixed'));

set @lastTool:= last_insert_id();
insert into HandTool VALUES (@lastTool);
set @lastTool:= last_insert_id();
insert into HandRatchet (id, drive_size) VALUES (@lastTool, .5);


# Garden tools insert
#Garden tool:1
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (2.0, 2.25, 6, 'Dewalt', 'steel', 15.60, 5.33, 66.9, @gardenCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Digger'), (select id from SubOption where name = 'edger'));

set @lastTool:= last_insert_id();
insert into GardenTool (id, handle_material) VALUES (@lastTool, 'wood');
set @lastTool:= last_insert_id();
insert into DiggingTool (id, blade_width, blade_length) VALUES (@lastTool, NULL, .25);

#Garden tool:2
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (8.0, 5, 132, 'Fiskars', 'steel', 14, 5.25, 35, @gardenCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Pruner'), (select id from SubOption where name = 'sheer'));

set @lastTool:= last_insert_id();
insert into GardenTool (id, handle_material) VALUES (@lastTool, 'Fiberglass');
set @lastTool:= last_insert_id();
insert into PruningTool (id, blade_material, blade_length) VALUES (@lastTool, 'steel', 1.5);

#Garden tool:3
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (26, 3, 71, 'Ames', 'plastic', 8, 3, 20, @gardenCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Rakes'), (select id from SubOption where name = 'leaf'));

set @lastTool:= last_insert_id();
insert into GardenTool (id, handle_material) VALUES (@lastTool, 'steel');
set @lastTool:= last_insert_id();
insert into RakeTool (id, tine_count) VALUES (@lastTool, 39);

#Garden tool:4
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (36, 3, 66, 'Midwest Gloves', 'metal', 22.124, 8.2965, 55.31, @gardenCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Rakes'), (select id from SubOption where name = 'landscaping'));

set @lastTool:= last_insert_id();
insert into GardenTool (id, handle_material) VALUES (@lastTool, 'aluminum');
set @lastTool:= last_insert_id();
insert into RakeTool (id, tine_count) VALUES (@lastTool, 40);

#Garden tool:5
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (4, 2, 44.5, 'Gardeners', 'steel', 27.98, 10.4925, 69.95, @gardenCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Rakes'), (select id from SubOption where name = 'rock'));

set @lastTool:= last_insert_id();
insert into GardenTool (id, handle_material) VALUES (@lastTool, 'wood');
set @lastTool:= last_insert_id();
insert into RakeTool (id, tine_count) VALUES (@lastTool, 4);

# Ladder Tools Insert
#Ladder tool : 1
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (2.0, 2.25, 6, 'Dewalt', 'steel', 15.60, 5.33, 33.0, @ladderCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Step'), (select id from SubOption where name = 'folding'));

set @lastTool:= last_insert_id();
insert into LadderTool (id, step_count, weight_capacity) VALUES (@lastTool, 10, 6.3);
set @lastTool:= last_insert_id();
insert into StepLadder (id, pail_shelf) VALUES (@lastTool, true);

#Ladder tool : 2
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (22.8, 4.63, 29.1, 'Finether', 'Aluminium', 24, 9, 60, @ladderCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Step'), (select id from SubOption where name = 'folding'));

set @lastTool:= last_insert_id();
insert into LadderTool (id, step_count, weight_capacity) VALUES (@lastTool, 3, 330);
set @lastTool:= last_insert_id();
insert into StepLadder (id, pail_shelf) VALUES (@lastTool, true);

#Ladder tool : 3
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (22.4, 13.4, 28.5, 'Louisville', 'fiberglass', 15.60, 5.33, 33.0, @ladderCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Straight'), (select id from SubOption where name = 'telescoping'));

set @lastTool:= last_insert_id();
insert into LadderTool (id, step_count, weight_capacity) VALUES (@lastTool, 6, 300);
set @lastTool:= last_insert_id();
insert into StraightLadder (id, rubber_feet) VALUES (@lastTool, 6);

#Ladder tool : 4
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (18.125, 13.4, 144, 'Werner', 'Aluminium', 70.4, 26.4, 176, @ladderCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Straight'), (select id from SubOption where name = 'telescoping'));

set @lastTool:= last_insert_id();
insert into LadderTool (id, step_count, weight_capacity) VALUES (@lastTool, 12, 300);
set @lastTool:= last_insert_id();
insert into StraightLadder (id, rubber_feet) VALUES (@lastTool, 12);

#Ladder tool : 5
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (18, 19, 126, 'Xtend & Climb', 'steel', 58, 21.75, 145, @ladderCategoryId, @manualPowerSourceId, (select id from SubType where name = 'Straight'), (select id from SubOption where name = 'telescoping'));

set @lastTool:= last_insert_id();
insert into LadderTool (id, step_count, weight_capacity) VALUES (@lastTool, 12, 225);
set @lastTool:= last_insert_id();
insert into StraightLadder (id, rubber_feet) VALUES (@lastTool, 10.5);

# Power Tool insert
#power tool: 1
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (22.0, 2.25, 6, 'Dewalt', 'steel', 14, 88.98, 55, @powerCategoryId, @dcPowerSourceId, (select id from SubType where name = 'Drill'), (select id from SubOption where name = 'hammer'));

set @lastTool:= last_insert_id();
insert into PowerTool (id, volt_rating, amp_rating, min_rpm_rating, max_rpm_rating) VALUES (@lastTool, 110, 30, 2000, 4500);
set @lastTool:= last_insert_id();
insert into PowerDrill (id, adjustable_clutch, min_torque_rating, max_torque_rating) VALUES (@lastTool, true, 80.5, NULL);


#Power tool accessory
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Drill Bits', 6, @lastTool);

#power tool:2
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (7.2, 5.6, 12, 'Dewalt', 'steel', 40, 15, 100, @powerCategoryId, @dcPowerSourceId, (select id from SubType where name = 'Drill'), (select id from SubOption where name = 'hammer'));

set @lastTool:= last_insert_id();
insert into PowerTool (id, volt_rating, amp_rating, min_rpm_rating, max_rpm_rating) VALUES (@lastTool, 36, 5, 0, 1600);
set @lastTool:= last_insert_id();
insert into PowerDrill (id, adjustable_clutch, min_torque_rating, max_torque_rating) VALUES (@lastTool, true, 80.5, NULL);

#Power tool accessory
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('36.0V 5.0A Li-ION Battery', 1, @lastTool);
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Power drill bits', 1, @lastTool);
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Soft Carrying case', 1, @lastTool);


#power tool:3
insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (18.66, 132, 21.64, 'Eagle', 'steel', 220, 82.5, 550, @powerCategoryId, @acPowerSourceId, (select id from SubType where name = 'Air-Compressor'), (select sb.id from SubOption sb JOIN SubType st ON sb.subtype_id = st.id where sb.name = 'reciprocating' AND st.name = 'Air-Compressor'));

set @lastTool:= last_insert_id();
insert into PowerTool (id, volt_rating, amp_rating, min_rpm_rating, max_rpm_rating) VALUES (@lastTool, 115, 14, 0, 2400);
set @lastTool:= last_insert_id();
insert into PowerAirCompressor (id, tank_size, pressure_rating) VALUES (@lastTool, 20, 125);

#Power tool accessory
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Puma 20-Piece Air Compressor Accessory Kit', 1, @lastTool);
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Eagle Hybri-Flex 1/4inch x 25inch Air Hose w/ 1/4inch MNPT Fittings', 1, @lastTool);
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Freeman Mini-Palm Nailer', 1, @lastTool);
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Campbell Hausfeld Caulk Gun', 1, @lastTool);
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Legacy Air Powered Grease Gun w/Extension', 1, @lastTool);

#power tool:4

insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (14.64, 132, 8.85, 'Milwaukee', 'steel', 100, 37.5, 250, @powerCategoryId, @dcPowerSourceId, (select id from SubType where name = 'Saw'), (select id from SubOption where name = 'circular'));

set @lastTool:= last_insert_id();
insert into PowerTool (id, volt_rating, amp_rating, min_rpm_rating, max_rpm_rating) VALUES (@lastTool, 18, 14, 0, 5000);
set @lastTool:= last_insert_id();
insert into PowerSaw (id, blade_size) VALUES (@lastTool, 7.25);

#Power tool accessory
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Diablo 7-1/4 in. x 60-Tooth Fine Finish Saw Blade', 2, @lastTool);
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('MilwaukeeM18 FUEL 18-Volt Lithium-Ion Cordless SAWZALL Reciprocating Saw with M18 9.0Ah Starter Kit', 1, @lastTool);

#power tool:5

insert into Tool (width, weight, length, manufacturer, material, deposit_price, rental_price, original_price, Category_Id, PowerSource_Id, SubType_Id, SubOption_Id)
VALUES (25, 515, 48, 'Generac', 'aluminum ', 1120, 420, 2800, @powerCategoryId, @dcPowerSourceId, (select id from SubType where name = 'Generator'), (select id from SubOption where name = 'electric'));

set @lastTool:= last_insert_id();
insert into PowerTool (id, volt_rating, amp_rating, min_rpm_rating, max_rpm_rating) VALUES (@lastTool, 120, 200, 0, 3600);
set @lastTool:= last_insert_id();
insert into PowerGenerator (id, power_rating) VALUES (@lastTool, 22000);

#Power tool accessory
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Scheduled maintaince kit', 1, @lastTool);
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Auxiliary transfer switch lockout', 1, @lastTool);
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Fasica base wrap', 1, @lastTool);
insert into Accessory (description, quantity, PowerTool_Id) VALUES ('Wireless local monitor', 1, @lastTool);




# Reservations
#insert into Reservation (booking_date, start_date, end_date, Customer_UserName, DropOffClerk_UserName, PickupClerk_UserName)
#VALUES (NOW(), '2017-10-02', '2017-10-12', 'thebatman', NULL, NULL);

INSERT INTO `Reservation` VALUES (1,'2017-11-26 09:15:24','2017-10-02 00:00:00','2017-10-12 00:00:00','thebatman',NULL,NULL),(2,'2017-11-26 08:57:50','2017-11-26 00:00:00','2017-11-28 00:00:00','thor',NULL,NULL),(3,'2017-11-26 09:16:24','2017-12-15 00:00:00','2017-12-30 00:00:00','thor',NULL,NULL),(4,'2017-11-26 09:17:55','2017-11-29 00:00:00','2017-11-30 00:00:00','thehulk',NULL,NULL),(5,'2017-11-26 09:18:25','2017-11-28 00:00:00','2017-11-29 00:00:00','thehulk',NULL,NULL),(6,'2017-11-26 09:19:01','2017-12-01 00:00:00','2017-12-03 00:00:00','thehulk',NULL,NULL);


# Sale Order
insert into SaleOrder (for_sale_date, sold_date, purchase_price, Customer_UserName, Tool_Id, Clerk_UserName)
VALUES ('2017-10-02', '2017-10-09', 47.88, 'thebatman', 1, 'admin@gatech.edu');

# Service Order
insert into ServiceOrder (start_date, end_date, service_cost, Tool_Id)
VALUES ('2017-10-02', '2017-10-09', 47.88, 1);

# Tool Reservation
#INSERT INTO ToolReservations (Tool_Id, Reservations_Id) VALUES (1, 1);
#INSERT INTO ToolReservations (Tool_Id, Reservations_Id) VALUES (2, 1);
#INSERT INTO `ToolReservations` VALUES (6,2),(7,2);

INSERT INTO `ToolReservations` VALUES (1,1),(2,1),(6,2),(7,2),(17,3),(18,3),(19,3),(20,3),(6,4),(7,4),(8,4),(9,4),(2,5),(4,5),(5,5),(21,6),(22,6);

# Tool Rentals
INSERT INTO Rentals (Tool_Id, start_date, end_date, number_of_rentals) VALUES (1, '2017-10-02', '2017-10-12', 1);
INSERT INTO Rentals (Tool_Id, start_date, end_date, number_of_rentals) VALUES (2, '2017-10-02', '2017-10-12', 2);