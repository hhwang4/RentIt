--Login--
------------
SELECT password FROM 'User' WHERE email='$Email';

-- View PROFILE --
------------------
/* Find the current User using the User.email; Display users first and last name;*/
SELECT first_name, last_name FROM `User` WHERE User.email='$UserID';

/*Find the current RegularUser using the user Email; Display RegularUser Sex, Birthdate, CurrentCity,
Hometown, and Interests. */
SELECT first_name, last_name, gender, birthdate, current_city, home_town FROM `User`
INNER JOIN RegularUser ON `User`.email=RegularUser.email WHERE
`User`.email='$UserID';


/* Find and display the current user interests:*/
SELECT interest FROM UserInterests WHERE email='$UserID';

/* Find each School for the RegularUser:
Display School name and Years Graduated;
Find School Type;
Display SchoolType Name; */
SELECT school_name, year_graduated FROM Attend WHERE email='$UserID' ORDER BY year_graduated DESC;

/* For each employer for the regular User, display Employer Name and Job Titles */
SELECT employer_name, job_title FROM Employment WHERE email='$UserID' ORDER BY employer_name DESC;