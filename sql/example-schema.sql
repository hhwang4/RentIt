CREATE TABLE Persons (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
);

INSERT INTO Persons(`PersonID`, `LastName`, `FirstName`, `Address`, `City`)
values (1, "Wayne", "Bruce", "Wayne Manor", "Gotham");

INSERT INTO Persons(`PersonID`, `LastName`, `FirstName`, `Address`, `City`)
values (2, "Parker", "Peter", "123 Main Street", "New York");

INSERT INTO Persons(`PersonID`, `LastName`, `FirstName`, `Address`, `City`)
values (3, "Kent", "Clark", "Farmland", "Metropolis");