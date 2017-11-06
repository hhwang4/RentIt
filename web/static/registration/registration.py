import json


class Phone:
    insert_phone = "insert into PhoneNumber (area_code, number, extension, type, `primary`, Customer_UserName) values(%s, %s, %s, %s, %s, %s);"

    def __init__(self, ac=None, number=None, ext=None, primary=None, t=None, customer=None, id=None):
        self.area_code = ac
        self.number = number
        self.ext = ext
        self.primary = primary
        self.type = t
        self.customer = customer
        self.id = id

    def create(self, connection):
        connection.execute(self.insert_phone,
                           [self.area_code, self.number, self.ext, self.type, self.primary, self.customer.userName])
        self.id = connection.lastrowid
        return self


class Address:
    sql_address = "insert into Address (street, city, state, zip) values(%s,%s,%s,%s);"

    def __init__(self, street=None, city=None, state=None, zip=None, id=None):
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        self.id = id

    def create(self, connection):
        connection.execute(self.sql_address, [self.street, self.city, self.state, self.zip])
        self.id = connection.lastrowid
        return self


class CreditCard:
    sql_cc = "insert into CreditCard (name, card_number, cvc, expiration_month, expiration_year) VALUES (%s, %s, %s, %s, %s);"

    def __init__(self, number=None, name=None, expiration_month=None, expiration_year=None, cvc=None, id=None):
        self.number = number
        self.name = name
        self.expiration_month = expiration_month
        self.expiration_year = expiration_year
        self.cvc = cvc
        self.id = id

    def create(self, connection):
        connection.execute(self.sql_cc, [self.name, self.number, self.cvc, self.expiration_month, self.expiration_year])
        self.id = connection.lastrowid
        return self


class Customer:
    sql_customer = "INSERT INTO Customer (user_name, first_name, middle_name, last_name, email, password, Address_Id, CreditCard_Id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s);"

    def __init__(self, dict):
        self.id = None
        vars(self).update(dict)

        self.homePhoneNumber = None if self.homePhone is None else Phone(ac=self.homePhoneAreaCode,
                                                                         number=self.homePhone, ext=self.homePhoneExt,
                                                                         t='home',
                                                                         primary=self.primaryPhone == 'home')

        self.cellPhoneNumber = None if self.cellPhone is None else Phone(ac=self.cellPhoneAreaCode,
                                                                         number=self.cellPhone, ext=self.cellPhoneExt,
                                                                         t='cell',
                                                                         primary=self.primaryPhone == 'cell')

        self.workPhoneNumber = None if self.workPhone is None else Phone(ac=self.workPhoneAreaCode,
                                                                         number=self.workPhone, ext=self.workPhoneExt,
                                                                         t='work',
                                                                         primary=self.primaryPhone == 'work')

        self.location = Address(street=self.address, city=self.city, state=self.state, zip=self.zip)
        self.credit_card = CreditCard(number=self.cardNumber, name=self.cardName, cvc=self.cvc,
                                      expiration_month=self.expirationMonth, expiration_year=self.expirationYear)

    def can_register_username(self, connection):
        sql_statement = "SELECT user_name from Customer as c where c.user_name = '{}';".format(self.userName)
        connection.execute(sql_statement)
        result = connection.fetchone()
        return result is None or len(result) == 0

    def can_register_email(self, connection):
        sql_statement = "SELECT email from Customer as c where c.email = '{}';".format(self.email)
        connection.execute(sql_statement)
        result = connection.fetchone()
        return result is None or len(result) == 0

    def create(self, connection):
        connection.execute(self.sql_customer, [self.userName, self.firstName, self.middleName, self.lastName,
                                               self.email, self.password, self.location.id, self.credit_card.id])
        self.id = connection.lastrowid

    def register(self, db, connection):
        if self.id is not None or self.id > 0:
            raise "Can't register a customer that already exists!"

        self.location = self.location.create(connection)
        db.commit()
        self.credit_card = self.credit_card.create(connection)
        db.commit()
        self.create(connection)
        db.commit()

        if self.homePhoneNumber is not None:
            self.homePhoneNumber.customer = self
            self.homePhoneNumber = self.homePhoneNumber.create(connection)
            db.commit()

        if self.cellPhoneNumber is not None:
            self.cellPhoneNumber.customer = self
            self.cellPhoneNumber = self.cellPhoneNumber.create(connection)
            db.commit()

        if self.workPhoneNumber is not None:
            self.cellPhoneNumber.customer = self
            self.workPhoneNumber = self.workPhoneNumber.create(connection)
            db.commit()
