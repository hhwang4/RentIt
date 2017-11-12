from flask import jsonify

class Reservation:
    def __init__(self, con=None, username=""):
        self.con = con
        self.user = username

    def create_reservation(self, tools, start_date, end_date, customer_username):
        self._checkConnection()

        toolsNotReserved = []
        toolsReserved = []
        cursor = self.con.cursor()

        # Check all ids to see if any can't be reserved
        tool_ids = [(tool.get('id')) for tool in tools]
        query = 'SELECT TR.tool_id FROM Reservation AS R INNER JOIN ToolReservations AS TR ON TR.Reservations_Id=R.id WHERE (%s BETWEEN start_date and end_date OR %s BETWEEN start_date and end_date) AND TR.tool_id IN %s'
        cursor.execute(query, (start_date, end_date, tool_ids))
        tools_with_reservations_found = cursor.fetchall()

        # If no existing reservations, insert
        if len(tools_with_reservations_found) == 0:
            # Create a reservation
            query = 'INSERT INTO Reservation (booking_date, start_date, end_date, Customer_UserName) VALUES (NOW(), %s, %s, %s)'
            cursor.execute(query, (start_date, end_date, customer_username))
            reservation_id = cursor.lastrowid

            rows = [(tool_id, reservation_id) for tool_id in tool_ids]
            query = 'INSERT INTO ToolReservations (Tool_Id, Reservations_Id) VALUES (%s, %s)'
            cursor.executemany(query, rows)
            self.con.commit()
            response = {'success': True, 'status_code': 200, 'reservation_id': reservation_id, 'tool_ids': tool_ids}
        else:
            tool_ids = [tool_id for tool_id, in tools_with_reservations_found]
            response = {'success': False, 'status_code': 500, 'tool_ids': tool_ids}

        # close connection
        self._closeConnection(cursor)

        return response

    def old_get_pickup_reservation(self, reservation_id):
        """
            Pickup a specific reservation for a customer.
        """
        self._checkConnection()
        cursor = self.con.cursor()
        query = 'SELECT R.id AS ReservationNumber, C.user_name AS CustomerUsername, c.id AS CustomerId, concat(C.first_name, " ", C.last_name) AS CustomerName, R.start_date, R.end_date FROM Customer AS C INNER JOIN Reservation AS R ON C.user_name=R.Customer_UserName WHERE R.id=%s'
        cursor.execute(query, (reservation_id))
        data = cursor.fetchone()

        if data:
            reservation_id, customer_username, customer_id, start_date, end_date = data
            reservation = {
                "reservation_id": reservation_id,
                "customer_username": customer_username,
                "customer_id": customer_id,
                "start_date": start_date.strftime('%m/%d/%Y'),
                "end_date": end_date.strftime('%m/%d/%Y')
            }
        else:
            reservation = None

        response = {'success': True, 'status_code': 200, 'reservations': jsonify(reservation)}
        self._closeConnection(cursor)

        return response

    def get_pickup_reservations(self):
        """
            Get all available reservation for this customer.
        """
        self._checkConnection()

        cursor = self.con.cursor()
        query = 'SELECT R.id AS ReservationNumber, C.user_name AS CustomerUsername, C.id AS CustomerId, concat(C.first_name, " ", C.last_name) AS CustomerName, R.start_date, R.end_date, SUM(rental_price), SUM(deposit_price) ' \
                'FROM Customer AS C INNER JOIN Reservation AS R ON C.user_name=R.Customer_UserName ' \
                'INNER JOIN ToolReservations AS TR ON TR.Reservations_Id=R.id ' \
                'INNER JOIN Tool AS T ON T.id=TR.Tool_id ' \
                'WHERE R.PickupClerk_UserName IS NULL'
        cursor.execute(query)
        data = cursor.fetchall()

        reservations = []

        if len(data):
            for reservation_id, customer_username, customer_id, customer_name, start_date, end_date, total_rental_price, total_deposit_price in data:
                if reservation_id:
                    reservations.append({
                        "reservation_id": reservation_id,
                        "customer_username": customer_username,
                        "customer_name": customer_name,
                        "customer_id": customer_id,
                        "start_date": (start_date and start_date.strftime('%m/%d/%Y')) or None,
                        "end_date": (end_date and end_date.strftime('%m/%d/%Y')) or None,
                        'total_rental_price': str(total_rental_price),
                        'total_deposit_price': str(total_deposit_price),
                    })

        response = {'success': True, 'status_code': 200, 'reservations': reservations}
        self._closeConnection(cursor)

        return response

    def pickup_reservation(self, reservation_id, clerk_username):
        """
            Record a reservation as picked up and add tools reserved to rentals.
        """
        self._checkConnection()

        cursor = self.con.cursor()

        # update the reservation with pickup clerk
        query = 'UPDATE Reservation SET PickupClerk_UserName=%s, booking_date=NOW() WHERE id=%s'
        cursor.execute(query, (clerk_username, reservation_id))

        # get all tools in reservation and add them to rentals
        query = 'SELECT TR.Tool_id, T.manufacturer, T.deposit_price, T.rental_price FROM ToolReservations AS TR  INNER JOIN Tool AS T ON TR.Tool_Id=T.id WHERE TR.Reservations_id=%s'
        cursor.execute(query, (reservation_id))
        tools_in_reservation = cursor.fetchall()
        tool_ids = tools = None
        if len(tools_in_reservation):
            tools = [{'id': tool_id, 'description': manufacturer, 'deposit_price': str(deposit_price),
                      'rental_price': str(rental_price)} for tool_id, manufacturer, deposit_price, rental_price in
                     tools_in_reservation]
            tool_ids = [(tool.get('id')) for tool in tools]
            query = 'INSERT INTO Rentals (Tool_Id, start_date, number_of_rentals) VALUE (%s, NOW(), 1)  ON DUPLICATE KEY UPDATE start_date=NOW(), end_date=NULL, number_of_rentals=number_of_rentals + 1;'
            cursor.executemany(query, tool_ids)
            self.con.commit()

        response = {'success': True, 'status_code': 200, 'reservation_id': reservation_id, 'tool_ids': tool_ids,
                    'tools': tools}
        self._closeConnection(cursor)

        return response

    def get_pickup_reservation(self, reservation_id):
        self._checkConnection()
        cursor = self.con.cursor()
        query = 'SELECT concat(C.first_name, " ", C.last_name) AS CustomerName, C.user_name, SUM(rental_price), SUM(deposit_price), R.start_date, R.end_date FROM Customer AS C INNER JOIN Reservation AS R ON C.user_name=R.Customer_UserName INNER JOIN ToolReservations AS TR ON TR.Reservations_Id=R.id INNER JOIN Tool AS T ON T.id=TR.Tool_id WHERE R.id=%s'
        cursor.execute(query, (reservation_id))
        data = cursor.fetchone()
        details = None
        if data:
            customer_full_name, customer_username, total_rental_price, total_deposit_price, start_date, end_date = data
            details = {
                'customer_full_name': customer_full_name,
                'customer_username': customer_username,
                'total_rental_price': str(total_rental_price),
                'total_deposit_price': str(total_deposit_price),
                'start_date': start_date.strftime('%m/%d/%Y'),
                'end_date': end_date.strftime('%m/%d/%Y')
            }

        response = {'success': True, 'status_code': 200, 'reservation_id': reservation_id, 'details': details}
        self._closeConnection(cursor)

        return response

    # DROPOFF RESERVATION
    def get_dropoff_reservations(self):
        """
            Get all available reservation for this customer.
        """
        self._checkConnection()

        cursor = self.con.cursor()
        query = 'SELECT R.id AS ReservationNumber, C.user_name AS CustomerUsername, concat(C.first_name, " ", C.last_name) AS CustomerName, R.start_date, R.end_date FROM Customer AS C INNER JOIN Reservation AS R ON C.user_name=R.Customer_UserName WHERE R.DropOffClerk_UserName IS NULL'
        cursor.execute(query)
        data = cursor.fetchall()

        reservations = []

        for reservation_id, customer_username, customer_id, customer_name, start_date, end_date in data:
            reservations.append({
                "reservation_id": reservation_id,
                "customer_username": customer_username,
                "customer_name": customer_name,
                "customer_id": customer_id,
                "start_date": start_date.strftime('%m/%d/%Y'),
                "end_date": end_date.strftime('%m/%d/%Y')
            })

        response = {'success': True, 'status_code': 200, 'reservations': reservations}
        self._closeConnection(cursor)

        return response

    def dropoff_reservation(self, reservation_id, clerk_username):
        """
            Record a reservation as picked up and add tools reserved to rentals.
        """
        self._checkConnection()

        cursor = self.con.cursor()
        # Update the reservation with dropoff clerk
        query = 'UPDATE Reservation SET DropOffClerk_UserName=%s WHERE id=%s'
        cursor.execute(query, (clerk_username, reservation_id))
        # Get all tools in reservation and update end dates in Rentals
        query = 'SELECT TR.Tool_id, T.manufacturer, T.deposit_price, T.rental_price FROM ToolReservations AS TR  INNER JOIN Tool AS T ON TR.Tool_Id=T.id WHERE TR.Reservations_id=%s'
        cursor.execute(query, (reservation_id))
        tools_in_reservation = cursor.fetchall()
        tool_ids = tools = None
        if len(tools_in_reservation):
            tools = [{'id': tool_id, 'description': manufacturer, 'deposit_price': str(deposit_price),
                      'rental_price': str(rental_price)} for tool_id, manufacturer, deposit_price, rental_price in
                     tools_in_reservation]
            tool_ids = [(tool.get('id')) for tool in tools]
            query = 'UPDATE Rentals SET end_date=NOW() WHERE Tool_Id in (%s)'
            cursor.executemany(query, tool_ids)
            # Check for rentals over 50 and add sales order
            query = 'SELECT Tool_Id FROM Rentals WHERE number_of_rentals >= 50'
            cursor.execute(query)
            result = cursor.fetchall()
            if len(result) > 0:
                tool_ids = [(tool_id, tool_id) for tool_id, in result]
                query = 'INSERT INTO SaleOrder (Tool_Id, for_sale_date, purchase_price, Clerk_UserName) VALUES (%s, NOW(), (SELECT original_price FROM Tool WHERE id=%s) * 0.5, "jwatson@tools4rent.com")'
                cursor.executemany(query, tool_ids)

            self.con.commit()

        response = {'success': True, 'status_code': 200, 'reservation_id': reservation_id, 'tool_ids': tool_ids,
                    'tools': tools}
        self._closeConnection(cursor)

        return response

    def get_dropoff_reservation(self, reservation_id):
        self._checkConnection()
        cursor = self.con.cursor()
        query = 'SELECT concat(C.first_name, " ", C.last_name) AS CustomerName, SUM(rental_price), SUM(deposit_price) FROM Customer AS C INNER JOIN Reservation AS R ON C.user_name=R.Customer_UserName INNER JOIN ToolReservations AS TR ON TR.Reservations_Id=R.id INNER JOIN Tool AS T ON T.id=TR.Tool_id WHERE R.id=%s'
        cursor.execute(query, (reservation_id))
        data = cursor.fetchone()
        details = None
        if data:
            customer_full_name, total_rental_price, total_deposit_price = data
            details = {
                'customer_full_name': customer_full_name,
                'total_rental_price': str(total_rental_price),
                'total_deposit_price': str(total_deposit_price)
            }

        response = {'success': True, 'status_code': 200, 'reservation_id': reservation_id, 'details': details}
        self._closeConnection(cursor)

        return response
        # HELPER  METHODS

    def _checkConnection(self):
        if self.con == None:
            raise "Connection to database should be set first"

    def _closeConnection(self, cursor=None):
        self.con.close()
        cursor.close()
