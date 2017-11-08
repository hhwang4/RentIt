from flask import Flask, render_template, request, jsonify
from flask import abort
from flaskext.mysql import MySQL
import decimal
import flask.json
import json
import datetime
from static.reservation.reservation import Reservation
from static.registration.registration import Customer


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
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
# app.config['MYSQL_DATABASE_HOST'] = 'mysql'  # mysql is the name of the docker container
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


@app.route("/")
def hello():
    return render_template('index.html')


@app.route("/old")
def old_hello():
    return render_template('index_old.html')


@app.route("/addtool")
def add_tool():
    # code here
    # grab data from request
    # request data to database
    # DB gives results
    # result to json
    return json.dumps(
        {'success': True}), \
           200, json_content


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
    con = mysql.connect()
    data = request.json
    reservation = Reservation(con)
    result = reservation.create_reservation(data.get('tools'), data.get('start_date'), data.get('end_date'),
                                            data.get('customer_username'))

    return create_response(result)


@app.route("/tools")
def tools():
    result = []

    data = request.json
    cursor = mysql.connect().cursor()
    cursor.execute("SELECT id, manufacturer, rental_price, deposit_price FROM Tool")

    data = cursor.fetchall()
    for tool_id, man, rent, deposit in data:
        result.append({
            'id': tool_id,
            'description': man,
            'rental_price': rent,
            'deposit_price': deposit
        })
    return jsonify(result)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
