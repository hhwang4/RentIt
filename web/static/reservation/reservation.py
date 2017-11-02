def createReservation(con, tools, start_date, end_date, customer_username):
    toolsNotReserved = []
    toolsReserved = []
    cursor = con.cursor()

    # Check all ids to see if any can't be reserved
    tool_ids = [(tool['id']) for tool in tools]
    query = "SELECT TR.tool_id FROM Reservation AS R INNER JOIN ToolReservations AS TR ON TR.Reservations_Id=R.id WHERE (%s BETWEEN start_date and end_date OR %s BETWEEN start_date and end_date) AND TR.tool_id IN %s"
    cursor.execute(query, (start_date, end_date, tool_ids))
    results = cursor.fetchall()

    # If no existing reservations, insert
    if len(results) == 0:
        # Create a reservation
        query = "INSERT INTO Reservation (booking_date, start_date, end_date, Customer_UserName) VALUES (NOW(), %s, %s, %s)"
        cursor.execute(query, (start_date, end_date, customer_username))
        reservation_id = cursor.lastrowid

        rows = [(tool_id, reservation_id) for tool_id in tool_ids]
        query = "INSERT INTO ToolReservations (Tool_Id, Reservations_Id) VALUES (%s, %s);"
        cursor.executemany(query, rows)
        con.commit()
        response = { 'success': True, 'status_code': 200, 'reservation_id': reservation_id, 'tool_ids': tool_ids }
    else:
        tool_ids = [id for id, in results]
        response = { 'success': False, 'status_code': 500, 'tool_ids': tool_ids }

    con.close()
    cursor.close()

    return response

def searchReservation():
    query = "SELECT Tool_Id FROM ToolReservations WHERE Tool_Id  NOT IN (SELECT TR.Tool_Id FROM Reservation AS R INNER JOIN ToolReservations AS TR ON TR.Reservations_Id=R.id WHERE DropOffClerk_UserName IS NULL or end_date > @start_date) UNION SELECT id FROM Tool WHERE id NOT IN (SELECT Tool_Id FROM ToolReservations);"

