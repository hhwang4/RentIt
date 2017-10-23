import json

from flask import Flask, render_template, request
from flask import abort
from flaskext.mysql import MySQL

app = Flask(__name__)
mysql = MySQL()
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'mypassword'
app.config['MYSQL_DATABASE_DB'] = 'cs6400_sfa17_team033'
# app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.config['MYSQL_DATABASE_HOST'] = 'mysql'  # mysql is the name of the docker container
app.config['MYSQL_DATABASE_HOST'] = '192.168.99.100'  # mysql is the name of the docker container
mysql.init_app(app)


@app.route("/")
def hello():
    return render_template('index.html')


@app.route("/customer/login", methods=['POST'])
def login():
    login_info = request.json
    cursor = mysql.connect().cursor()
    cursor.execute("SELECT password from Customer as c where c.user_name = '{}';".format(login_info['username']))
    pw = cursor.fetchall()[0][0]

    if login_info["password"] == pw:
        return json.dumps({'success': True}), 200, {'ContentType': 'application/json'}
    else:
        abort(400)


@app.route("/myindex")
def myindex():
    cursor = mysql.connect().cursor()
    cursor.execute("SELECT * from Persons")
    data = cursor.fetchall()

    return render_template('index_old.html', data=data)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
