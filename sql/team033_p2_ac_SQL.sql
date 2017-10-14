use cs6400_fa17_team033;

# Login Customer
set @username := 'thebatman';
SELECT password FROM Customer WHERE user_name=@username;

# Login Clerk
set @clerkUsername := 'admin@gatech.edu';
SELECT password FROM Clerk WHERE user_name=@clerkUsername;

# Change Password
set @newpassword = 'mynewpassword';
update Clerk set password = @newpassword where user_name = @clerkUsername;
update Clerk set temp_password = NULL where user_name = @clerkUsername;

# Registration
set @street = '123 main street', @city = 'Gotham City', @state = 'NY', @zip ='55555-5555';
insert into Address (street, city, state, zip) values(@street, @city,@state, @zip);
set @addressId := last_insert_id();

set @cardname = 'Bruce Wayne', @card_number = '1234567801', @cvc = '021', @expiration_month = 8, @expiration_year = 2020;
insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) VALUES (@cardname, @card_number, @cvc, @expiration_month, @expiration_year);
set @ccId = last_insert_id();

set @primaryPhone = 1, @user_name = 'TheJoker', @first_name = 'Mr', @middle_name = 'J', @last_name = 'Joker', @email = 'crimeclown@aol.com', @password = 'bats';
set @cellphoneId = NULL, @homephoneId = NULL, @workphoneId = NULL;


INSERT INTO Customer (user_name, primary_phone, first_name, middle_name, last_name, email, password, Address_Id, CellPhoneNumber_Id, CreditCard_Id, HomePhoneNumber_Id, WorkPhoneNumber_Id)
VALUES (@user_name, @primaryPhone, @first_name, @middle_name, @last_name, @email, @password, @addressId, @cellphoneId, @ccId, @homephoneId, @workphoneId);

-- View PROFILE --
------------------

/* View Customer task */

/* Find the User using the Username; Display the email, full name */
SELECT email, first_name, middle_name, last_name, p.area_code as cellAc, p.extension as cellExt, p.number as cellNumber, 
q.area_code as workAc, q.extension as workExt, q.number as workNumber, 
r.area_code as homeAc, r.extension as homeExt, r.number as homeNumber,
city, street, zip, state
FROM Customer as c
JOIN Address as a on a.id = c.Address_Id
LEFT OUTER JOIN PhoneNumber as p on c.CellPhoneNumber_Id = p.id
LEFT OUTER JOIN PhoneNumber as q on c.WorkPhoneNumber_Id = q.id
LEFT OUTER JOIN PhoneNumber as r on c.HomePhoneNumber_Id = r.id
WHERE user_name=@username;

/* #TODO:Question & Review */
/*■ For each Phone under this Customer.Username
● Display the phone number */


/*■ Find Address using Customer.Username; Display address (city, street,
state, zip) */
SELECT city, street, state, zip FROM 'Address' INNER JOIN Customer ON Customer.address_id = Address.id WHERE Customer.user_name='$UserName';

/* ○ View Reservations task */ 
/*
■ Find rental history
● For each Reservation for the Customer.Username
○ Display Reservation Number, StartDate, EndDate,*/
SELECT id, start_date, end_date FROM 'Reservation' WHERE Reservation.Customer_UserName='$UserName';

/*#TODO
○ Calculate Number of Days from StartDate/EndDate
*/



/*
○ Find Tool based on Tool.Number; Display Name, Deposit
Price, Rental Price*/
/* #TODO:Question Where is Display Name of tool in tool table? --> I suppose here it is tool_Id (please delete if i am wrong)*/
SELECT Tool_Id, deposit_price, rental_price FROM 'ToolReservations' INNER JOIN Reservation ON Reservation.id = Reservations_Id WHERE Customer_UserName='$UserName';


/*
○ Find Clerk based on Drop-off Clerk.Number, Pick-up
Clerk.Number; Display Clerk.Name for both Pick-Up and
Drop-Off clerk */
/*#TODO:CHANGE I think we need to change here from clerk.Number to Clerk.Username as it is the common between Reservation table and clerk table*/
/*#TODO:QUESTION & REVIEW : I THINK THIS CAN BE DONE IN ONE QUERY WITH AND*/
SELECT first_name, middle_name, last_name, employee_number FROM Clerk INNER JOIN Reservation ON Reservation.DropOffClerk_UserName= Clerk.user_name WHERE Customer_UserName='$UserName';
SELECT first_name, middle_name, last_name, employee_number FROM Clerk INNER JOIN Reservation ON Reservation.PickUpClerk_UserName= Clerk.user_name WHERE Customer_UserName='$UserName';


--Check Tool Availability--
---------------------------
/* ● User clicks Check Availability link
● User inputs Start Date, End Date, Keywords, Power Source, Sub-Type and/or Type
● Run Tool Search task where Reservation.ToolNumber equals ToolNumbers from
search and Reservation.StartDate...EndDate not equal to Start Date, End Date
○ If more than 10 tools are returned
■ Display prompt for user to specify more criteria
○ Else
■ For each Tool; Display Tool Number, Description (aggregate), Rental
Price, Deposit Price
● User clicks Tool details link,
○ Find Tool using Tool.Number; Display Description, Deposit Price, Rental Price
○ Run Full Tool Details task; Display Tool ID, Tool Type, Short Description, Full
Description (concatenated) , Deposit Price, Rental Price.
*/

--#TODO

--Tool Search--
---------------
/* User clicks Search button
○ For each Tool that matches the ToolNumber.ToolType, PowerSource, SubTypes,
and/or keyword search.
■ Return Tool.Number, Tool.Name, RentalPrice, and DepositPrice*/
--#TODO:QUESTION & REVIEW: I think we need to add those to the Tool table, because user can search for them without having a Tool Reservation.
--#TODO:QUESTION & REVIEW: For each Tool that matches the ToolNumber.ToolType, .. I think we need to change this in abstract code?!
--#TODO:QUESTION & REVIEW: OR/AND don't remember how to do it in same clause.
--#TODO:QUESTION & REVIEW: Tool.Number thingy?!!
SELECT id, name, rental_price, deposit_price FROM 'Tool' INNER JOIN ((Category ON Category.id=Category_Id WHERE Category.name='$CategoryName') OR/AND 
														(PowerSource ON PowerSource.id=PowerSource_Id WHERE PowerSource.name='$PowerSourceName') OR/AND
														(SubType ON SubType.id=SubType_Id WHERE SubType.name='$SubTypeName'))

--#TODO

--FULL TOOL DETAILS--
---------------------
/* ● User clicked button that requires detailed description
● Find Hand, Garden, Ladder, Power, etc. (including accessories, materials, etc) based
on Tool.Number; Display full description*/

--#TODO

--MAKE RESERVATION--
--------------------
/* ● User clicks Make Reservation button from Main Menu
● User enters Start Date, End Date, Keywords, Power Source, Sub-Type and/or Type
● Run Tool Search task where Reservation.ToolNumber equals ToolNumbers from
search and Reservation.StartDate...EndDate not equal to Start Date, End Date
○ For each Tool; Display Tool Number, Short Description, Rental Price, Deposit
Price
● User clicks Add button
Table of Contents
Phase 1 Report | CS 6400 - Fall 2017 | Team 033
○ If less than 11 tools already added
■ If tool count reaches 0
● Display error message
■ Else
● Add tool to reservation list section
○ Else
■ Display error message for user to reduce the number of tools in the
current reservation to 10.
○ If the tool is being returned within next 24 hours
■ Display info message
● User clicks Remove button
○ Remove item from reservation list section
● User clicks Calculate Total button
○ Run Reservation Summary task
■ Displays Reservation Dates, Number of Days
■ Calculate total deposits, and rental price; Display Total Deposit, Rental
Price
■ User clicks Submit button
● For each tool to be reserved, find ToolNumber
○ If ToolNumber is not in Reservation with open EndDate
■ Write new Reservation record, return
ReservationNumber
■ Update Reservation Summary to be Reservation
Confirmation
● Display ReservationNumber
○ Else
■ Redirect User to Make Reservation form
■ Remove item from Tools Added to Reservation list
■ Update Available Tools For Rent list
■ User clicks Reset button*/

--#TODO

--Purchase Tool--
-----------------

/* ● User clicks Purchase Tool button from Main Menu
● User enters Keyword, Type, Sub-Type, and/or Power Source
● User clicks Search button
○ Run Tool Search task : find tools w/ no SoldDate in SaleOrder
○ User clicks Purchase Tool button
■ Add tool to purchase list
○ User clicks Submit button
■ Find each SaleOrder for ToolNumber
● Find Credit Card using Customer.Username
○ Process CreditCard.Number for Customer.Username
● Run Purchase tool task
○ Update SoldDate -> now() and Customer.Number for
SaleOrder
○ Run Purchase Confirmation task
■ Display ConfirmationNumber*/

--#TODO

--Pick-up RESERVATION--
-----------------------
/* ● User clicks Pick-Up button from Main Menu
● Run Pick-Up Reservation task
○ For each Reservation where Reservation.EndDate is NULL
■ Find the Customer.Name from Customer using
Reservation.CustomerNumber
■ Display ReservationNumber, CustomerNumber, CustomerName,
StartDate, and EndDate
● User clicks ID link or enters ID and clicks Pick-Up button
● Run Pick-Up Reservation Summary task
○ Find the Customer.name from Reservation.CustomerNumber
○ Display TotalDeposit, CustomerName, TotalRentalRrice
○ Find CreditCard with Reservation.CustomerNumber
○ If User clicks New button
■ Run Credit Card Information task
● User enters credit card name, credit card number, CVC, expiration
month, and expiration year
● If user clicks Confirm Pick Up button
○ Insert Customer.Number, CreditCardName,
CreditCardNumber, CVC, ExpirationDate in CreditCard
○ Insert Customer.Number, CreditCard.Number in
CustomerCreditCard
● User clicks Confirm Pick Up button
● Run Rental Contract task
○ Update Reservation with Pick-Up clerk’s Clerk.Number, BookingDate -> now()
○ Display Pick-UpClerkName, CustomerName, CreditCard XXXX, Start Date, End
Date
○ For each Tool.Number in Reservation
■ Find Tool.Name, DepositPrice, RentalPrice*/

--#TODO

--Drop-Off Reservation--
------------------------

/*● User clicks Drop-Off button from Main Menu
● Run Drop-Off Reservation task
○ For each Reservation with Reservation.DropOffClerk is NULL
■ Find the Customer.Name from Reservation.CustomerNumber
■ Display, ReservationNumber, CustomerNumber, CustomerName,
StartDate, and EndDate
● User clicks ID link or enters ID and clicks Drop-Off button
● Run Drop-Off Reservation Summary task
○ Find the Customer.Name from Reservation.CustomerNumber
○ Display TotalDeposit, CustomerName, TotalRentalRrice
○ Calculate TotalDue; Display TotalDue
● Run Rental Contract task
○ Update Reservation with Drop-Off clerk’s Clerk.Number
○ Display Drop-OffClerk.Name, CustomerName, CreditCard XXXX, Start Date, End
Date
○ For each Tool.Number in Reservation
■ Find Tool.Name, DepositPrice, RentalPrice
○ User clicks Tool Name link
■ Run Full Tool Details task*/

--#TODO


--Add New Tool--
----------------
/*Abstract Code
● User clicks Add Tool from Main Menu
● User selects Type
● Run Sub-Type/Sub-Option task
○ Find Sub-Type based on Type; Populate Sub-Type menu
○ Validate that tool type and power-source are selected first before allowing
sub-type and sub-options
○ Find Sub-Option based on Type, Sub-Type; Populate Sub-Option menu
● User enters Purchase Price
● Calculate the Deposit Price and Rental Prices
● User select Hand Tool radio button
○ Update menu options
○ User enters Manufacturer, Width, Width Fraction, Width Unit, Length, Weight,
Length Fraction, Length Unit, Drive/Chuck Size (if applicable)
● User select Power Tool radio button
○ Find Power Source based on Type, Sub-Type; Populate Power Source menu
○ Update menu options
○ User enters Power :Source, Gauge Unit, Capacity Unit, A/C Volt Rating, Power
Generated, Power Fraction, Power Unit, Torque Min/Max, Pressure Min/Max,
Speed Min/Max
○ User enters Power Tool Accessory Quantity, Description
○ User clicks Add Accessory button
■ Add another accessory input fields
○ Validate User enters multiple speed for variable speed devices and one speed for
single speed devices
● User select Cordless Tool option
○ Update menu options
○ User enters Battery Type, Quantity, D/C Volt Rating
● Convert measurements
● Validate all fields have values based on type
● User clicks Add Tool button
○ Insert Tool price, weight, etc. into Tool
● Go to Main Menu form*/

--#TODO


--Service Order / Repair Tool--
-------------------------------
/*
Abstract Code
● User clicks Repair Tool from Main Menu
● User enters StartDate, EndDate, Keyword, Type, Power Source, Sub-Type
● Run Tool Search task: where tools not in ServiceOrder.ToolNumber <> Tool.Number or
ServiceOrder.ToolNumber == Tool.Number and EndDate <> Null
○ For each Tool
■ Display ToolNumber, Description, Rental Price, and Deposit Price
● User clicks Service Tool button
○ Update list of tools to service
● User enters Tool ID
○ Validate that tool does not have a service order
● User enters Service Cost
● User clicks Confirm button
○ Run Service Tool task
■ Create ServiceOrder record with ClerkNumber, StartDate, Cost*/

--#TODO

--Service Status--
------------------
/*Abstract Code
● User clicks Service Status button from Main Menu
● User enters StartDate, EndDate, Keyword, Type, Power Source, Sub-Type
● Run Tool Search task: where ServiceOrder.EndDate is NULL
○ Display ServiceNumber, Status, ToolNumber, Description, StartDate, EndDate
RepairCost, Clerk.Name
● User clicks Fix Now? Button
○ Update EndDate to now(), ClerkNumber to current Clerk*/

--#TODO

--Sell Tool--
-------------
/*Abstract Code
● User clicks on Sell Tool button from Main Menu
● User enters StartDate, EndDate, Keyword, Type, Power Source, Sub-Type
● Run Tool Search task: where count of Reservation.EndDate is greater than or equal to50
○ For each Tool
■ Display ToolNumber, Description, RentalPrice, DepositPrice
● User clicks Sell Tool
○ Create SaleOrder, with ToolNumber, ForSaleDate*/

--#TODO

--Sale Status--
---------------
/*Abstract Code
● User clicks Sale Status button from Main Menu
● User enters StartDate, EndDate, Keyword, Type, Power Source, Sub-Type
● Run Tool Search task: where ServiceOrder exists
○ Display ServiceNumber, Status (ServiceOrder.EndDate <> NULL -> Sold),
ToolNumber, Description, StartDate, EndDate RepairCost, Clerk.ID
○ If “Sold” (ServiceOrder.EndDate <> NULL -> Sold)
■ Display SalePrice, SaleDate
*/

--#TODO


--Generate Report--
-------------------
/*Abstract Code
● User clicks Reports button from Main Menu
● Display Clerk Report link, Customer Report link, and Tool Inventory link
● User clicks Clerk Report link
○ Go to Clerk Report
○ For each Clerk
■ Display Number, First Name, Middle Name, Last Name, Email, Hiring
Date
■ Sum number of pickups and dropoffs with Clerk.Number
■ Calculate Total; Display Number of Pickups, Dropoffs, Combined Total
● User clicks Customer Report link
○ Go to Customer Report
■ For each Customer
● Display Customer Number, First Name, Middle Name, Last Name,
Email, Phone
● Count Reservation with Customer.Number; Display Total
Reservations
● Count Reservation.ToolNumber with Customer.Number; Display
Total Tools Rented
○ User clicks View Profile , then go to View Profile page
● User clicks Tool Inventory link
○ Go to Tool Inventory Report
○ User enters All Tools, Hand Tool, Garden Tool, Ladder, Power Tool, Keyword i
○ User clicks Search button
○ Run Tool Search task
■ For each Tool
● Display ToolNumber, Description,
● Find CurrentStatus, Date; Display CurrentStatus Date
● Sum all rental prices collected and subtract cost
● Sum all cost, original cost, repairs;
● Calculate Total Profit; Display Rental Profit, Total Cost, Total Profit*/

--#TODO