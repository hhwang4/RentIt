import json
json_content = {'ContentType': 'application/json'}

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
        details = []
        cursor = self.cursor
        cursor.callproc("ToolDetails", [tool_id])
        data = cursor.fetchone()
        #col_names = ['toolId', 'category', 'short_desc', 'full_desc', 'powersource', 'subtype', 'suboption', 'rental_price',
        #            'deposit_price', 'material', 'width', 'weight', 'length', 'manufacturer', 'acc_description']

        details.append({
            'id': data[0],
            'tool_type': data[1],
            'short_description': data[2],
            'full_description': data[3],
            'deposit_price': str(data[8]),
            'rental_price': str(data[7]),
            'accessories': data[14]
        })

        response = {'success': True, 'status_code': 200, 'details': details}
        return response
