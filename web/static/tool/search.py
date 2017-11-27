class Search:
    def reservation(self, start_date, end_date):
        query = "SELECT T.id FROM Tool AS T WHERE T.id " \
                "NOT IN (SELECT TR.Tool_Id FROM ToolReservations AS TR INNER JOIN Reservation AS R ON TR.Reservations_Id=R.id WHERE ('{}' BETWEEN R.start_date AND R.end_date) OR ('{}' BETWEEN R.start_date AND R.end_date) " \
                "OR ('{}' <= R.start_date AND '{}' >= R.end_date)) " \
                "AND T.id NOT IN (SELECT Tool_Id FROM SaleOrder) " \
                "AND T.id NOT IN ( SELECT Tool_Id FROM ServiceOrder AS ServiceO WHERE ServiceO.start_date >= '{}' AND ServiceO.end_date <= '{}')".format(start_date, end_date, start_date, end_date, start_date, end_date)

        return query

    def tool_availability(self, start_date, end_date):
        query = "SELECT T.id FROM Tool AS T WHERE T.id " \
                "NOT IN (SELECT TR.Tool_Id FROM ToolReservations AS TR INNER JOIN Reservation AS R ON TR.Reservations_Id=R.id WHERE ('{}' BETWEEN R.start_date AND R.end_date) OR ('{}' BETWEEN R.start_date AND R.end_date) " \
                "OR ('{}' <= R.start_date AND '{}' >= R.end_date)) " \
                "NOT IN (SELECT Tool_Id FROM SaleOrder) AND T.id " \
                "NOT IN ( SELECT Tool_Id FROM ServiceOrder AS ServiceO WHERE ServiceO.start_date >= '{}' AND ServiceO.end_date <= '{}')".format(start_date, end_date, start_date, end_date)

        return query
