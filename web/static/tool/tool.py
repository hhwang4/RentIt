json_content = {'ContentType': 'application/json'}

class Tool:
    def __init__(self, con, cursor):
        self.con = con
        self.cursor = cursor

    def search(self, start_date="", end_date="", keyword="", category="", sub_type="", power_source="", tool_query=""):
        cursor = self.cursor
        tools = []
        if category == "all":
            query = "SELECT tool.id, category.name, powersource.name, subtype.name, suboption.name, rental_price, deposit_price " \
                    "FROM Tool AS tool JOIN SubOption AS suboption ON suboption.id = tool.SubOption_Id JOIN SubType AS subtype ON subtype.id = tool.SubType_Id " \
                    "JOIN PowerSource AS powersource ON powersource.id = tool.PowerSource_Id " \
                    "JOIN Category AS category ON category.id = tool.Category_Id " \
                    "WHERE tool.id IN ({})".format(tool_query)
            cursor.execute(query)
        else:
            query = "SELECT tool.id, category.name, powersource.name, subtype.name, suboption.name, rental_price, deposit_price " \
                    "FROM Tool AS tool JOIN SubOption AS suboption ON suboption.id = tool.SubOption_Id JOIN SubType AS subtype ON subtype.id = tool.SubType_Id " \
                    "JOIN PowerSource AS powersource ON powersource.id = tool.PowerSource_Id " \
                    "JOIN Category AS category ON category.id = tool.Category_Id " \
                    "WHERE subtype.name = %s AND powersource.name = %s AND category.name = %s AND tool.id IN ({})".format(tool_query)
            cursor.execute(query, (sub_type, power_source, category))

        data = cursor.fetchall()

        for tool_id, category, powersource, subtype, suboption, rental_price, deposit_price in data:
            tools.append({
                'id': tool_id,
                'description': "{} {} {}".format(powersource, suboption, subtype),
                'rental_price': str(rental_price),
                'deposit_price': str(deposit_price)
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

        query = "SELECT description " \
                "FROM Accessory " \
                "WHERE PowerTool_Id = {}".format(tool_id)
        cursor.execute(query)
        accessories_result = cursor.fetchall()
        accessories_list = []
        for desc in accessories_result:
            accessories_list.append(desc[0])
        details.append({
            'id': data[0],
            'tool_type': data[1],
            'short_description': data[2],
            'full_description': data[3],
            'deposit_price': str(data[8]),
            'rental_price': str(data[7]),
            'accessories': accessories_list
        })

        response = {'success': True, 'status_code': 200, 'details': details}
        return response
