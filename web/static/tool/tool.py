class Tool:
    def __init__(self, con, cursor):
        self.con = con
        self.cursor = cursor

    def search(self, start_date="", end_date="", keyword="", type="", sub_type="", power_source="", tool_query=""):
        cursor = self.cursor
        tools = []

        cursor.execute("SELECT id, manufacturer, rental_price, deposit_price FROM Tool WHERE id IN ({})".format(tool_query))
        data = cursor.fetchall()

        for tool_id, man, rent, deposit in data:
            tools.append({
                'id': tool_id,
                'description': man,
                'rental_price': str(rent),
                'deposit_price': str(deposit)
            })
        response = {'success': True, 'status_code': 200, 'tools': tools}

        return response
