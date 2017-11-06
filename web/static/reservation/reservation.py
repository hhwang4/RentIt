from flask import jsonify
import datetime
from decimal import Decimal

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
        tool_ids = [(tool['id']) for tool in tools]
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
            response = { 'success': True, 'status_code': 200, 'reservation_id': reservation_id, 'tool_ids': tool_ids }
        else:
            tool_ids = [tool_id for tool_id, in tools_with_reservations_found]
            response = { 'success': False, 'status_code': 500, 'tool_ids': tool_ids }

        # close connection
        self._closeConnection(cursor)

        return response

   # HELPER  METHODS
    def _checkConnection(self):
        if self.con == None:
            raise "Connection to database should be set first"

    def _closeConnection(self, cursor=None):
        self.con.close()
        cursor.close()
