class Search:
    def __init__(self):
        pass

    def reservation(self, start_date, end_date):
        query = "SELECT Tool_Id FROM ToolReservations AS TR WHERE Tool_Id " \
                "NOT IN (SELECT TR.Tool_Id FROM Reservation AS R INNER JOIN ToolReservations AS TR ON TR.Reservations_Id=R.id " \
                "WHERE DropOffClerk_UserName IS NULL or ('{}' BETWEEN start_date and end_date OR '{}' BETWEEN start_date and end_date) " \
                "UNION SELECT id FROM Tool WHERE id NOT IN (SELECT Tool_Id FROM ToolReservations)".format(start_date, end_date)

        query = "SELECT T.id FROM Tool AS T WHERE T.id " \
                "NOT IN (SELECT TR.Tool_Id FROM ToolReservations AS TR INNER JOIN Reservation AS R ON TR.Reservations_Id=R.id WHERE ('{}' BETWEEN R.start_date AND R.end_date) OR ('{}' BETWEEN R.start_date AND R.end_date)) AND T.id " \
                "NOT IN (SELECT Tool_Id FROM SaleOrder) AND T.id " \
                "NOT IN ( SELECT Tool_Id FROM ServiceOrder AS ServiceO WHERE ServiceO.start_date >= '{}' AND ServiceO.end_date <= '{}')".format(start_date, end_date, start_date, end_date)

        return query

    def tool_availability(self, start_date, end_date):
        query = "SELECT T.id FROM Tool AS T WHERE T.id " \
                "NOT IN (SELECT TR.Tool_Id FROM ToolReservations AS TR INNER JOIN Reservation AS R ON TR.Reservations_Id=R.id WHERE ('{}' BETWEEN R.start_date AND R.end_date) OR ('{}' BETWEEN R.start_date AND R.end_date)) AND T.id " \
                "NOT IN (SELECT Tool_Id FROM SaleOrder) AND T.id " \
                "NOT IN ( SELECT Tool_Id FROM ServiceOrder AS ServiceO WHERE ServiceO.start_date >= '{}' AND ServiceO.end_date <= '{}')".format(start_date, end_date, start_date, end_date)

        return query
