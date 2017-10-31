def createReservation(con, tools, start_date, end_date, customer_username):
    toolsNotReserved = []
    toolsReserved = []
    cursor = con.cursor()

    # Create a reservation
    query = "INSERT INTO Reservation (booking_date, start_date, end_date, Customer_UserName) VALUES (NOW(), %s, %s, %s)"
    cursor.execute(query, (start_date, end_date, customer_username))
    reservation_id = cursor.lastrowid

    # For each tool, determine if it has a reservation for the specified date and if not, reserve tools
    for tool in tools:
        query = "SELECT R.id FROM Reservation AS R INNER JOIN ToolReservations AS TR ON TR.Reservations_Id=R.id WHERE end_date > %s AND TR.tool_id=%s"
        cursor.execute(query, (start_date, tool['id']))

        if cursor.fetchone() == None:
            query = "INSERT INTO ToolReservations VALUES (%s, %s);"
            cursor.execute(query, (tool['id'], reservation_id))
        else:
            toolsNotReserved.append(tool)
    cursor.close()

    return { 'reservation_id': reservation_id, 'toolsNotReserved': toolsNotReserved, "toolsReserved": toolsReserved }

def searchReservation():
    query = "SELECT Tool_Id FROM ToolReservations WHERE Tool_Id  NOT IN (SELECT TR.Tool_Id FROM Reservation AS R INNER JOIN ToolReservations AS TR ON TR.Reservations_Id=R.id WHERE DropOffClerk_UserName IS NULL or end_date > @start_date) UNION SELECT id FROM Tool WHERE id NOT IN (SELECT Tool_Id FROM ToolReservations);"

