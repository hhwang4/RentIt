create database cs6400_sfa17_team033;

use cs6400_sfa17_team033;

CREATE TABLE `Customer` (
	`id` INT NOT NULL AUTO_INCREMENT,
    `user_name` NVARCHAR(128) NOT NULL,
    `primary_phone` INT NOT NULL,
    `first_name` VARCHAR(128) NOT NULL,
    `middle_name` VARCHAR(128) NOT NULL,
    `last_name` VARCHAR(128) NOT NULL,
    `email` VARCHAR(128) NOT NULL,
    `password` LONGTEXT NOT NULL,
    `Address_Id` INT NOT NULL,
    `CellPhoneNumber_Id` INT,
    `CreditCard_Id` INT NOT NULL,
    `HomePhoneNumber_Id` INT,
    `WorkPhoneNumber_Id` INT,
    PRIMARY KEY (`user_name`),
    UNIQUE(`email`),
    UNIQUE(`id`)
);

CREATE TABLE `Address` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `street` VARCHAR(255) NOT NULL,
    `city` VARCHAR(128) NOT NULL,
    `state` VARCHAR(128) NOT NULL,
    `zip` VARCHAR(10) NOT NULL,
    PRIMARY KEY (`id`)
);


CREATE TABLE `PhoneNumber` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `area_code` VARCHAR(3) NOT NULL,
    `number` VARCHAR(12) NOT NULL,
    `extension` VARCHAR(10),
    PRIMARY KEY (`id`)
);


CREATE TABLE `CreditCard` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(128) NOT NULL,
    `card_number` VARCHAR(128) NOT NULL,
    `cvc` VARCHAR(3) NOT NULL,
    `expiration_month` INT NOT NULL,
    `expiration_year` INT NOT NULL,
    PRIMARY KEY (`id`)
);


CREATE TABLE `Clerk` (
    `user_name` NVARCHAR(128) NOT NULL,
    `date_of_hire` DATETIME NOT NULL,
    `temp_password` LONGTEXT,
    `employee_number` INT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(128) NOT NULL,
    `middle_name` VARCHAR(128) NOT NULL,
    `last_name` VARCHAR(128) NOT NULL,
    `email` VARCHAR(128) NOT NULL,
    `password` LONGTEXT NOT NULL,
    PRIMARY KEY (`user_name`),
    UNIQUE(`email`),
    UNIQUE(`employee_number`)
);


CREATE TABLE `Reservation` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `booking_date` DATETIME NOT NULL,
    `start_date` DATETIME NOT NULL,
    `end_date` DATETIME NOT NULL,
    #`total_deposit_price` DECIMAL(18 , 2 ) NOT NULL, #removed because these should be derived
    #`total_rental_price` DECIMAL(18 , 2 ) NOT NULL, #removed because these should be derived
    `Customer_UserName` NVARCHAR(128) NOT NULL,
    `DropOffClerk_UserName` NVARCHAR(128),
    `PickupClerk_UserName` NVARCHAR(128),
    PRIMARY KEY (`id`)
);


CREATE TABLE `ToolReservations` (
	`Tool_Id` INT NOT NULL,
    `Reservations_Id` INT NOT NULL,
    PRIMARY KEY (`Tool_Id` , `Reservations_Id`)
);



CREATE TABLE `Tool` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `width` DOUBLE NOT NULL,
    `weight` DOUBLE NOT NULL,
    `length` DOUBLE NOT NULL,
    `manufacturer` VARCHAR(128) NOT NULL,
    `material` VARCHAR(128),
    `Category_Id` INT NOT NULL,
    `PowerSource_Id` INT NOT NULL,
    `SubOption_Id` INT NOT NULL,
    `SubType_Id` INT NOT NULL,
    `deposit_price` DECIMAL(18 , 2 ) NOT NULL,
    `rental_price` DECIMAL(18 , 2 ) NOT NULL,
    `original_price` DECIMAL(18 , 2 ) NOT NULL,
    PRIMARY KEY (`id`)
);


CREATE TABLE `Category` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(128) NOT NULL,
    PRIMARY KEY (`id`)
);


CREATE TABLE `PowerSource` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(128) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `SubType` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(128) NOT NULL,
    PRIMARY KEY (`id`)
);
CREATE TABLE `SubOption` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(128) NOT NULL,
    `SubType_Id` INT,
    PRIMARY KEY (`id`)
);

CREATE TABLE `Accessory` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `description` LONGTEXT NOT NULL,
    `quantity` INT NOT NULL,
    `PowerTool_Id` INT,
    PRIMARY KEY (`id`)
);

CREATE TABLE `ServiceOrder` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `start_date` DATETIME NOT NULL,
    `end_date` DATETIME NOT NULL,
    `service_cost` DECIMAL(18 , 2 ) NOT NULL,
    `Tool_Id` INT NOT NULL,
    UNIQUE(`Tool_Id`),
    PRIMARY KEY (`id`)
);


CREATE TABLE `SaleOrder` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `for_sale_date` DATETIME NOT NULL,
    `sold_date` DATETIME,
    `purchase_price` DECIMAL(18 , 2 ) NOT NULL,
    `Clerk_UserName` NVARCHAR(128),
    `Customer_UserName` NVARCHAR(128),
    `Tool_Id` INT NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `PowerSourceCategory` (
    `PowerSource_Id` INT NOT NULL,
    `Category_Id` INT NOT NULL,
    PRIMARY KEY (`PowerSource_Id` , `Category_Id`)
);

CREATE TABLE `SubTypePowerSource` (
    `SubType_Id` INT NOT NULL,
    `PowerSource_Id` INT NOT NULL,
    `Category_Id` INT NOT NULL,
    PRIMARY KEY (`SubType_Id` , `PowerSource_Id`, `Category_Id`)
);

CREATE TABLE `CordlessAccessory` (
    `id` INT NOT NULL,
    `volt_rating` DOUBLE NOT NULL,
    `amp_rating` DOUBLE NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `HandTool` (
    `id` INT NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `ScrewDriver` (
    `id` INT NOT NULL,
    `screw_size` INT NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `HandSocket` (
    `id` INT NOT NULL,
    `drive_size` DOUBLE NOT NULL,
    `sae_size` DOUBLE NOT NULL,
    `deep_socket` BOOL NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `HandRatchet` (
    `id` INT NOT NULL,
    `drive_size` DOUBLE NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `HandPlier` (
    `id` INT NOT NULL,
    `adjustable` BOOL NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `HandGun` (
    `id` INT NOT NULL,
    `gauge_rating` INT NOT NULL,
    `capacity` INT NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `HandHammer` (
    `id` INT NOT NULL,
    `anti_vibration` BOOL NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `PowerTool` (
    `id` INT NOT NULL,
    `volt_rating` DOUBLE NOT NULL,
    `amp_rating` DOUBLE NOT NULL,
    `min_rpm_rating` DOUBLE NOT NULL,
    `max_rpm_rating` DOUBLE,
    PRIMARY KEY (`id`)
);

CREATE TABLE `PowerDrill` (
    `id` INT NOT NULL,
    `adjustable_clutch` BOOL NOT NULL,
    `min_torque_rating` DOUBLE NOT NULL,
    `max_torque_rating` DOUBLE,
    PRIMARY KEY (`id`)
);

CREATE TABLE `PowerSaw` (
    `id` INT NOT NULL,
    `blade_size` DOUBLE NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `PowerSander` (
    `id` INT NOT NULL,
    `dust_bag` BOOL NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `PowerAirCompressor` (
    `id` INT NOT NULL,
    `tank_size` DOUBLE NOT NULL,
    `pressure_rating` DOUBLE,
    PRIMARY KEY (`id`)
);

CREATE TABLE `PowerMixer` (
    `id` INT NOT NULL,
    `motor_rating` DOUBLE NOT NULL,
    `drum_size` DOUBLE NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `PowerGenerator` (
    `id` INT NOT NULL,
    `power_rating` DOUBLE NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `CordlessPowerTool` (
    `id` INT NOT NULL,
    `battery_type` VARCHAR(7) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `LadderTool` (
    `id` INT NOT NULL,
    `step_count` INT,
    `weight_capacity` DOUBLE,
    PRIMARY KEY (`id`)
);

CREATE TABLE `StraightLadder` (
    `id` INT NOT NULL,
    `rubber_feet` BOOL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `StepLadder` (
    `id` INT NOT NULL,
    `pail_shelf` BOOL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `GardenTool` (
    `id` INT NOT NULL,
    `handle_material` VARCHAR(128) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `WheelBarrowTool` (
    `id` INT NOT NULL,
    `bin_material` VARCHAR(128) NOT NULL,
    `wheel_count` INT NOT NULL,
    `bin_volume` DOUBLE,
    PRIMARY KEY (`id`)
);

CREATE TABLE `PruningTool` (
    `id` INT NOT NULL,
    `blade_material` VARCHAR(128),
    `blade_length` DOUBLE NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `StrikingTool` (
    `id` INT NOT NULL,
    `head_weight` DOUBLE NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `DiggingTool` (
    `id` INT NOT NULL,
    `blade_width` DOUBLE,
    `blade_length` DOUBLE NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `RakeTool` (
    `id` INT NOT NULL,
    `tine_count` INT NOT NULL,
    PRIMARY KEY (`id`)
);
alter table `Customer` add constraint `FK_Customer_Address_Address_Id`  foreign key (`Address_Id`) references `Address` ( `id`) ;
alter table `Customer` add constraint `FK_Customer_PhoneNumber_CellPhoneNumber_Id`  foreign key (`CellPhoneNumber_Id`) references `PhoneNumber` ( `id`) ;
alter table `Customer` add constraint `FK_Customer_CreditCard_CreditCard_Id`  foreign key (`CreditCard_Id`) references `CreditCard` ( `id`)  on update cascade on delete cascade ;
alter table `Customer` add constraint `FK_Customer_PhoneNumber_HomePhoneNumber_Id`  foreign key (`HomePhoneNumber_Id`) references `PhoneNumber` ( `id`) ;
alter table `Customer` add constraint `FK_Customer_PhoneNumber_WorkPhoneNumber_Id`  foreign key (`WorkPhoneNumber_Id`) references `PhoneNumber` ( `id`) ;
alter table `Reservation` add constraint `FK_Reservation_Customer_Customer_UserName`  foreign key (`Customer_UserName`) references `Customer` ( `user_name`) ;
alter table `Reservation` add constraint `FK_Reservation_Clerk_DropOffClerk_UserName`  foreign key (`DropOffClerk_UserName`) references `Clerk` ( `user_name`) ;
alter table `Reservation` add constraint `FK_Reservation_Clerk_PickupClerk_UserName`  foreign key (`PickupClerk_UserName`) references `Clerk` ( `user_name`) ;
alter table `ToolReservations` add constraint `FK_ToolAvailability_Tool_Tool_Id`  foreign key (`Tool_Id`) references `Tool` ( `id`)  on update cascade on delete cascade ;
alter table `ToolReservations` add constraint `FK_ToolAvailability_Reservation_Reservations_Id`  foreign key (`Reservations_Id`) references `Reservation` ( `id`) ;
alter table `Tool` add constraint `FK_Tool_Category_Category_Id`  foreign key (`Category_Id`) references `Category` ( `id`)  on update cascade on delete cascade ;
alter table `Tool` add constraint `FK_Tool_PowerSource_PowerSource_Id`  foreign key (`PowerSource_Id`) references `PowerSource` ( `id`)  on update cascade on delete cascade ;
alter table `Tool` add constraint `FK_Tool_SubOption_SubOption_Id`  foreign key (`SubOption_Id`) references `SubOption` ( `id`)  on update cascade on delete cascade ;
alter table `Tool` add constraint `FK_Tool_SubType_SubType_Id`  foreign key (`SubType_Id`) references `SubType` ( `id`)  on update cascade on delete cascade ;
alter table `SubOption` add constraint `FK_SubOption_SubType_SubType_Id`  foreign key (`SubType_Id`) references `SubType` ( `id`) ;
alter table `Accessory` add constraint `FK_Accessory_PowerTool_PowerTool_Id`  foreign key (`PowerTool_Id`) references `PowerTool` ( `id`) ;
alter table `ServiceOrder` add constraint `FK_ServiceOrder_Tool_Tool_Id`  foreign key (`Tool_Id`) references `Tool` ( `id`)  on update cascade on delete cascade ;
alter table `SaleOrder` add constraint `FK_SaleOrder_Customer_Customer_UserName`  foreign key (`Customer_UserName`) references `Customer` ( `user_name`) ;
alter table `SaleOrder` add constraint `FK_SaleOrder_Clerk_Clerk_UserName`  foreign key (`Clerk_UserName`) references `Clerk` ( `user_name`) ;
alter table `SaleOrder` add constraint `FK_SaleOrder_Tool_Tool_Id`  foreign key (`Tool_Id`) references `Tool` ( `id`)  on update cascade on delete cascade ;
alter table `PowerSourceCategory` add constraint `FK_PowerSourceCategory_PowerSource_PowerSource_Id`  foreign key (`PowerSource_Id`) references `PowerSource` ( `id`)  on update cascade on delete cascade ;
alter table `PowerSourceCategory` add constraint `FK_PowerSourceCategory_Category_Category_Id`  foreign key (`Category_Id`) references `Category` ( `id`)  on update cascade on delete cascade ;
alter table `SubTypePowerSource` add constraint `FK_SubTypePowerSource_SubType_SubType_Id`  foreign key (`SubType_Id`) references `SubType` ( `id`)  on update cascade on delete cascade ;
alter table `SubTypePowerSource` add constraint `FK_SubTypePowerSource_PowerSource_PowerSource_Id`  foreign key (`PowerSource_Id`) references `PowerSource` ( `id`)  on update cascade on delete cascade ;
alter table `SubTypePowerSource` add constraint `FK_SubTypePowerSource_Category_Category_Id`  foreign key (`Category_Id`) references `Category` ( `id`)  on update cascade on delete cascade ;
alter table `CordlessAccessory` add constraint `FK_CordlessAccessory_Accessory_id`  foreign key (`id`) references `Accessory` ( `id`) ;
alter table `HandTool` add constraint `FK_HandTool_Tool_id`  foreign key (`id`) references `Tool` ( `id`) ;
alter table `ScrewDriver` add constraint `FK_ScrewDriver_HandTool_id`  foreign key (`id`) references `HandTool` ( `id`) ;
alter table `HandSocket` add constraint `FK_HandSocket_HandTool_id`  foreign key (`id`) references `HandTool` ( `id`) ;
alter table `HandRatchet` add constraint `FK_HandRatchet_HandTool_id`  foreign key (`id`) references `HandTool` ( `id`) ;
alter table `HandPlier` add constraint `FK_HandPlier_HandTool_id`  foreign key (`id`) references `HandTool` ( `id`) ;
alter table `HandGun` add constraint `FK_HandGun_HandTool_id`  foreign key (`id`) references `HandTool` ( `id`) ;
alter table `HandHammer` add constraint `FK_HandHammer_HandTool_id`  foreign key (`id`) references `HandTool` ( `id`) ;
alter table `PowerTool` add constraint `FK_PowerTool_Tool_id`  foreign key (`id`) references `Tool` ( `id`) ;
alter table `PowerDrill` add constraint `FK_PowerDrill_PowerTool_id`  foreign key (`id`) references `PowerTool` ( `id`) ;
alter table `PowerSaw` add constraint `FK_PowerSaw_PowerTool_id`  foreign key (`id`) references `PowerTool` ( `id`) ;
alter table `PowerSander` add constraint `FK_PowerSander_PowerTool_id`  foreign key (`id`) references `PowerTool` ( `id`) ;
alter table `PowerAirCompressor` add constraint `FK_PowerAirCompressor_PowerTool_id`  foreign key (`id`) references `PowerTool` ( `id`) ;
alter table `PowerMixer` add constraint `FK_PowerMixer_PowerTool_id`  foreign key (`id`) references `PowerTool` ( `id`) ;
alter table `PowerGenerator` add constraint `FK_PowerGenerator_PowerTool_id`  foreign key (`id`) references `PowerTool` ( `id`) ;
alter table `CordlessPowerTool` add constraint `FK_CordlessPowerTool_PowerTool_id`  foreign key (`id`) references `PowerTool` ( `id`) ;
alter table `LadderTool` add constraint `FK_LadderTool_Tool_id`  foreign key (`id`) references `Tool` ( `id`) ;
alter table `StraightLadder` add constraint `FK_StraightLadder_LadderTool_id`  foreign key (`id`) references `LadderTool` ( `id`) ;
alter table `StepLadder` add constraint `FK_StepLadder_LadderTool_id`  foreign key (`id`) references `LadderTool` ( `id`) ;
alter table `GardenTool` add constraint `FK_GardenTool_Tool_id`  foreign key (`id`) references `Tool` ( `id`) ;
alter table `WheelBarrowTool` add constraint `FK_WheelBarrowTool_GardenTool_id`  foreign key (`id`) references `GardenTool` ( `id`) ;
alter table `PruningTool` add constraint `FK_PruningTool_GardenTool_id`  foreign key (`id`) references `GardenTool` ( `id`) ;
alter table `StrikingTool` add constraint `FK_StrikingTool_GardenTool_id`  foreign key (`id`) references `GardenTool` ( `id`) ;
alter table `DiggingTool` add constraint `FK_DiggingTool_GardenTool_id`  foreign key (`id`) references `GardenTool` ( `id`) ;
alter table `RakeTool` add constraint `FK_RakeTool_GardenTool_id`  foreign key (`id`) references `GardenTool` ( `id`) ;
