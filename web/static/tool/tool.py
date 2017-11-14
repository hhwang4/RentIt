class Tool:
    def __init__(self, con, cursor):
        self.con = con
        self.cursor = cursor

    def search(self, start_date="", end_date="", keyword="", type="", sub_type="", power_source="", tool_query=""):
        cursor = self.cursor
        tools = []

        cursor.execute(
            "SELECT id, manufacturer, rental_price, deposit_price FROM Tool WHERE id IN ({})".format(tool_query))
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

    def specific_tool(self, tool_id):
        """
            Provides a details description of a tool
            :param tool_id: a tool id
            :return: a http response containing the details key (the json full details for a tool). The details json
            should look like
                details = {
                    id: '',
                    tool_type: '',
                    short_description: '',
                    full_description: '',
                    deposit_price: '',
                    rental_price: '',
                    accessories: [
                        'accessory1',
                        'accessory2',
                        'accessory3'
                    ]
                }
        """
        details = None

        response = {'success': True, 'status_code': 200, 'details': details}
        return response
