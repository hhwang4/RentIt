# -*- coding: utf-8 -*-
from flask import Flask, render_template, request, jsonify
from flaskext.mysql import MySQL
import decimal
import flask.json
import json
import datetime
import sys
from static.reservation.reservation import Reservation
from static.registration.registration import Customer
from static.add_tool import find_tool
from static.tool.search import Search
from static.tool.tool import Tool

class MyJSONEncoder(flask.json.JSONEncoder):
    """
        Custom json encorder to handle encoding Decimals
        source: https://stackoverflow.com/questions/24706951/how-to-convert-all-decimals-in-a-python-data-structure-to-string#24707102
    """

    def default(self, obj):
        if isinstance(obj, decimal.Decimal):
            # Convert decimal instances to strings.
            return str(obj)
        # if isinstance(obj, datetime.dateime):
        #     return obj.strftime("%Y-%m-%d %H:%M:%S")
        return super(MyJSONEncoder, self).default(obj)


app = Flask(__name__)
mysql = MySQL()
app.json_encoder = MyJSONEncoder

app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'mypassword'
app.config['MYSQL_DATABASE_DB'] = 'cs6400_sfa17_team033'
#app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.config['MYSQL_DATABASE_HOST'] = 'mysql'  # mysql is the name of the docker container
mysql.init_app(app)

json_content = {'ContentType': 'application/json'}


# Creates a json response
def create_response(result):
    return json.dumps({'success': result.get('success'), 'data': result}), result.get('status_code'), {
        'ContentType': 'application/json'}


def datetime_handler(x):
    if isinstance(x, datetime.datetime):
        return x.isoformat()
    if isinstance(x, decimal.Decimal):
        # Convert decimal instances to strings.
        return str(x)
    else:
        return x

def check_query_parameters(data, parameters):
    # TODO: Check the response data to make sure correct query parameter is provided, return error message
    pass

@app.route("/")
def hello():
    return render_template('index.html')


@app.route("/old")
def old_hello():
    return render_template('index_old.html')

@app.route("/addtool")
def add_tool_get():
    db = mysql.connect()
    cursor = db.cursor()

    result = dict()
    cursor.execute("SELECT Name FROM Category")
    category = [x[0] for x in cursor.fetchall()]
    for cat in category:
        result[cat] = dict()
        cursor.execute("SELECT SubType.Name FROM SubType, Category where SubType.Category_Id = Category.id AND Category.Name = %s", [cat])
        subtype = [x[0] for x in cursor.fetchall()]
        for t in subtype:
            cursor.execute("SELECT SubOption.Name FROM SubType, SubOption where SubOption.SubType_Id = SubType.id AND SubType.Name = %s", [t])
            result[cat][t] = [x[0] for x in cursor.fetchall()]
    cursor.close()
    db.close()
    return json.dumps({'success': True, 'data': result}), 200, json_content


@app.route("/addtool", methods=['POST'])
def add_tool_post():
    db = mysql.connect()
    cursor = db.cursor()
    params = request.get_json()
    try:
        tool = find_tool(params)
        tool.create(cursor)

        db.commit()
    except Exception as e:
       return json.dumps({'success': False, 'message': str(e)}), 500, json_content
    finally:
        cursor.close()
        db.close()

    return json.dumps({'success': True,}), 200, json_content

@app.route("/login", methods=['POST'])
def login():
    login_info = request.json

    if login_info['type'] == 'customer':
        sql_statement = "SELECT password from Customer as c where c.user_name = '{}';".format(login_info['username'])
    elif login_info['type'] == 'clerk':
        sql_statement = "SELECT password from Clerk as c where c.user_name = '{}';".format(login_info['username'])

    cursor = mysql.connect().cursor()
    try:
        cursor.execute(sql_statement)
        result = cursor.fetchall()
    finally:
        cursor.close()

    if cursor.rownumber != 1:
        return json.dumps(
            {'success': False,
             'type': login_info['type'],
             'message': 'There is no {} with username {}'.format(login_info['type'], login_info['username'])
             }), \
               404, json_content

    pw = result[0][0]

    if login_info["password"] == pw:
        return json.dumps({'success': True,
                           'type': login_info['type'],
                           'username': login_info['username']
                           }), 200, json_content
    else:
        return json.dumps(
            {'success': False,
             'type': login_info['type'],
             'message': 'Password is incorrect for {}'.format(login_info['username'])
             }), \
               400, json_content


@app.route("/myindex")
def myindex():
    return render_template('index.html')


@app.route("/customer/<username>")
def get_customer_profile(username):
    db = mysql.connect()
    cursor = db.cursor()

    try:
        cursor.callproc("CustomerInfo", [username])
        result = cursor.fetchone()
        return json.dumps(
            {'success': True,
             'data': result
             }), 200, json_content
    except Exception as e:
        print(e)
        return json.dumps(
            {'success': False,
             'message': 'User {} doesnt exist.'.format(username)
             }), 404, json_content
    finally:
        cursor.close()
        db.close()

@app.route("/customer/<username>/credit_cards", methods=['POST'])
def update_customer_credit_card(username):
    db = mysql.connect()
    cursor = db.cursor()
    cc_info = request.json

    try:
        query = 'UPDATE CreditCard AS CC INNER JOIN Customer AS C ON CC.id=C.CreditCard_Id SET name=%s, card_number=%s, cvc=%s, expiration_month=%s, expiration_year=%s WHERE C.user_name=%s'
        cursor.execute(query, (cc_info.get('cardName'), cc_info.get('cardNumber'), cc_info.get('cvc'),
                        cc_info.get('expirationMonth'), cc_info.get('expirationYear'), username))
        db.commit()

        return json.dumps(
            {'success': True,
             'data': 'Done'
             }), 200, json_content
    except Exception as e:
        print(e)
        return json.dumps(
            {'success': False,
             'message': 'Credit card could not be updated for {}'.format(username),
             }), 404, json_content
    finally:
        cursor.close()
        db.close()

@app.route("/reservations/<username>")
def get_customer_reservation(username):
    db = mysql.connect()
    cursor = db.cursor()

    try:
        cursor.callproc("ReservationsByUser", [username])
        result = cursor.fetchall()

        full_result = []
        if len(result) > 0 and result[0][0] is not None:
            for r in result:
                cursor.callproc("ToolNameShortByReservationId", [r[0]])
                tools = cursor.fetchall()
                full_result.append(list(r) + [tools])
                x = 0

        return json.dumps(
            {'success': True,
             'data': full_result
             }, default=datetime_handler), 200, json_content
    except Exception as e:
        print(e)
        return json.dumps(
            {'success': False,
             'message': 'User {} doesnt exist.'.format(username)
             }, default=datetime_handler), 404, json_content
    finally:
        cursor.close()
        db.close()


@app.route("/reports/clerk/<year>/<month>")
def get_clerk_report(year, month):
    db = mysql.connect()
    cursor = db.cursor()

    try:
        cursor.callproc("ClerkReport", [month, year])
        result = cursor.fetchall()

        return json.dumps(
            {'success': True,
             'data': result
             }, default=datetime_handler), 200, json_content
    except Exception as e:
        print(e)
        return json.dumps(
            {'success': False,
             }, default=datetime_handler), 404, json_content
    finally:
        cursor.close()
        db.close()


@app.route("/reports/customer/<year>/<month>")
def get_customer_report(year, month):
    db = mysql.connect()
    cursor = db.cursor()

    try:
        cursor.callproc("CustomerReport", [month, year])
        result = cursor.fetchall()

        return json.dumps(
            {'success': True,
             'data': result
             }, default=datetime_handler), 200, json_content
    except Exception as e:
        print(e)
        return json.dumps(
            {'success': False,
             }, default=datetime_handler), 404, json_content
    finally:
        cursor.close()
        db.close()


@app.route("/reports/tool/<pagenumber>/<itemsPerPage>")
def get_tool_report(pagenumber, itemsPerPage):
    pagenumber = int(pagenumber)
    itemsPerPage = int(itemsPerPage)
    db = mysql.connect()
    cursor = db.cursor()

    try:
        # LIMIT ({pagenumber}-1)*{itemsPerPage},{itemsPerPage}
        # todo replace with category ID and Date from request object
        day = datetime.datetime.now().strftime("%Y-%m-%d")
        cursor.callproc("ToolInventoryReport", [itemsPerPage, (pagenumber - 1) * itemsPerPage, day])
        result = cursor.fetchall()

        cursor.execute("select count(*) from Tool;")
        total_rows = cursor.fetchone()
        total_rows = 0 if total_rows is None or len(total_rows) == 0 else total_rows[0]

        return json.dumps(
            {'success': True,
             'totalsize': total_rows,
             'data': result
             }, default=datetime_handler), 200, json_content
    except Exception as e:
        print(e)
        return json.dumps(
            {'success': False,
             }, default=datetime_handler), 404, json_content
    finally:
        cursor.close()
        db.close()


@app.route("/register", methods=['POST'])
def register_customer():
    reg_info = request.json
    db = mysql.connect()
    cursor = db.cursor()

    try:
        customer = Customer(reg_info)
        email_check = customer.can_register_email(cursor)
        username_check = customer.can_register_username(cursor)
        if email_check and username_check:
            customer.register(db, cursor)
        else:
            if not email_check:
                return json.dumps(
                    {'success': False,
                     'message': 'A user already has the email address {}. Try another'.format(customer.email)
                     }), 400, json_content
            elif not username_check:
                return json.dumps(
                    {'success': False,
                     'message': 'A user already has the username {}. Try another'.format(customer.userName)
                     }), 400, json_content

    except Exception as e:
        print(e)
    finally:
        cursor.close()
        db.close()
    return json.dumps(
        {'success': True}), \
           200, json_content


@app.route("/reservations", methods=['POST'])
def make_reservation():
    """ Reserve specified tools"""
    db = mysql.connect()
    cursor = db.cursor()
    data = request.json

    try:
        reservation = Reservation(db, cursor)
        result = reservation.create_reservation(data.get('tools'), data.get('start_date'), data.get('end_date'),
                                                data.get('customer_username'))
    except Exception as e:
        result = {'success': False, 'status_code': 404, 'message': 'Tools could not be reserved'}
    finally:
        cursor.close()
        db.close()

    return create_response(result)

@app.route("/pickup_reservations/<int:reservation_id>", methods=['GET'])
def get_pickup_reservations(reservation_id):
    """Get all or a specific reservation"""
    db = mysql.connect()
    cursor = db.cursor()

    try:
        reservation = Reservation(db, cursor)
        result = reservation.get_pickup_reservation(reservation_id)
    except Exception as e:
        result = {'success': False, 'status_code': 404, 'message': "Could retrieve pickup reservation #{}".format(reservation_id)}
    finally:
        cursor.close()
        db.close()

    return create_response(result)


@app.route("/pickup_reservations", methods=['GET'])
def get_reservation():
    """Get all reservation pickups"""
    db = mysql.connect()
    cursor = db.cursor()

    try:
        reservation = Reservation(db, cursor)
        result = reservation.get_pickup_reservations()
    except Exception as e:
        result = {'success': False, 'status_code': 404, 'message': 'Could not retrieve pickup reservations details'}
    finally:
        cursor.close()
        db.close()

    return create_response(result)


@app.route("/pickup_reservations/<int:reservation_id>", methods=['POST'])
def post_pickup_reservation(reservation_id):
    db = mysql.connect()
    cursor = db.cursor()
    data = request.json
    clerk_username = data.get('clerk_username')

    try:
        reservation = Reservation(db, cursor)
        check_query_parameters(request, 'clerk_username')
        result = reservation.pickup_reservation(reservation_id, clerk_username)
    except Exception as e:
        print(e)
        result = {'success': False, 'status_code': 404, 'message': "Could not insert reservation #{} data".format(reservation_id)}
    finally:
        cursor.close()
        db.close()

    return create_response(result)

@app.route("/dropoff_reservations/<int:reservation_id>", methods=['GET'])
def get_dropoff_reservations(reservation_id):
    """Get all or a specific reservation"""
    db = mysql.connect()
    cursor = db.cursor()

    try:
        reservation = Reservation(db, cursor)
        result = reservation.get_dropoff_reservation(reservation_id)
    except Exception as e:
        result = {'success': False, 'status_code': 404, 'message': "Could not retrieve drop-off reservation #{}".format(reservation_id)}
    finally:
        cursor.close()
        db.close()

    return create_response(result)


@app.route("/dropoff_reservations", methods=['GET'])
def get_dropoff_all_reservation():
    """Get all reservation dropoffs"""
    db = mysql.connect()
    cursor = db.cursor()

    try:
        reservation = Reservation(db, cursor)
        result = reservation.get_dropoff_reservations()
    except Exception as e:
        result = {'success': False, 'status_code': 404, 'message': 'Could not get list of dropoff reservations'}
    finally:
        cursor.close()
        db.close()

    return create_response(result)


@app.route("/dropoff_reservations/<int:reservation_id>", methods=['POST'])
def post_dropoff_reservation(reservation_id):
    db = mysql.connect()
    cursor = db.cursor()
    data = request.json
    clerk_username = data.get('clerk_username')

    try:
        reservation = Reservation(db, cursor)
        check_query_parameters(request, 'clerk_username')
        result = reservation.dropoff_reservation(reservation_id, clerk_username)
    except Exception as e:
        result = {'success': False, 'status_code': 404, 'message': "Could not dropoff reservation #{}".format(reservation_id)}
    finally:
        cursor.close()
        db.close()

    return create_response(result)


@app.route("/tools/<tool_id>", methods=['GET'])
def tools_id(tool_id):
    db = mysql.connect()
    cursor = db.cursor()

    try:
        tool = Tool(db, cursor)
        result = tool.specific_tool(tool_id)
    except Exception as e:
        result = {'success': False, 'status_code': 404, 'message': "Tool search failed"}
    finally:
        cursor.close()
        db.close()

    return create_response(result)


@app.route("/tools")
def tools():
    db = mysql.connect()
    cursor = db.cursor()

    search_type = request.args.get('search_type')
    tool_query = None
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')
    keyword = request.args.get('keyword')
    type = request.args.get('type')
    power_source = request.args.get('power_source')
    sub_type = request.args.get('sub_type')
    search = Search()

    if search_type == 'reservation':
        tool_query = search.reservation(start_date, end_date)
    elif search_type == 'tool_availability':
        tool_query = search.tool_availability(start_date, end_date)

    try:
        tool = Tool(db, cursor)
        result = tool.search(start_date, end_date, keyword, type, sub_type, power_source, tool_query)

    except Exception as e:
        result = {'success': False, 'status_code': 404, 'message': "Tool search failed"}
    finally:
        cursor.close()
        db.close()

@app.route('/categories')
def get_categories():

    try:
        db = mysql.connect()
        cursor = db.cursor()
        cursor.execute('select id, name from Category;')
        data = cursor.fetchall()
        data = [{"id": r[0], "name": r[1]} for r in data]
        result = {'success': True, 'status_code': 200, 'data': data}
    except Exception as e:
        result = {'success': False, 'status_code': 500,
                  'message': "No Categories could be loaded"}
    finally:
        cursor.close()
        db.close()

    return create_response(result)

@app.route('/powersources/<int:category_id>')
def get_powersources(category_id):

    try:
        db = mysql.connect()
        cursor = db.cursor()
        cursor.execute('SELECT id, name FROM PowerSourceCategory AS psc JOIN PowerSource AS ps ON ps.id =  psc.PowerSource_Id WHERE psc.Category_Id =  %s ;', category_id)
        data = cursor.fetchall()
        data = [{"id": r[0], "name": r[1]} for r in data]
        result = {'success': True, 'status_code': 200, 'data': data}
    except Exception as e:
        result = {'success': False, 'status_code': 500,
                  'message': "No Power Sources could be loaded"}
    finally:
        cursor.close()
        db.close()

    return create_response(result)

@app.route('/subtypes/<int:category_id>/<int:powersource_id>')
def get_subtypes(category_id, powersource_id):

    try:
        db = mysql.connect()
        cursor = db.cursor()
        cursor.execute('select id, name FROM  SubTypePowerSource  AS  stps JOIN  SubType  AS  st  ON  st.id  =   stps.SubType_Id WHERE  stps.Category_Id  =   %s AND  stps.PowerSource_Id  = %s ;', [category_id, powersource_id])
        data = cursor.fetchall()
        data = [{"id": r[0], "name": r[1]} for r in data]
        result = {'success': True, 'status_code': 200, 'data': data}
    except Exception as e:
        result = {'success': False, 'status_code': 500,
                  'message': "No Subtypes could be loaded"}
    finally:
        cursor.close()
        db.close()

    return create_response(result)

@app.route('/suboptions/<int:category_id>/<int:powersource_id>/<int:subtype_id>')
def get_suboptions(category_id, powersource_id, subtype_id):

    try:
        db = mysql.connect()
        cursor = db.cursor()
        cursor.execute('SELECT so.id, so.name FROM SubOption AS so JOIN SubType AS st ON st.id =  so.SubType_Id JOIN SubTypePowerSource AS stps ON stps.SubType_Id =  st.id WHERE PowerSource_Id =  %s AND so.SubType_Id = %s AND stps.Category_Id =  %s ;', [powersource_id,subtype_id, category_id])
        data = cursor.fetchall()
        data = [{"id": r[0], "name": r[1]} for r in data]
        result = {'success': True, 'status_code': 200, 'data': data}
    except Exception as e:
        result = {'success': False, 'status_code': 500,
                  'message': "No Suboptions could be loaded"}
    finally:
        cursor.close()
        db.close()

    return create_response(result)

    return create_response(result)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
