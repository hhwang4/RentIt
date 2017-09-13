from flask import Flask, render_template
from flaskext.mysql import MySQL
import os
import socket

app = Flask(__name__)
mysql = MySQL()
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'mypassword'
app.config['MYSQL_DATABASE_DB'] = 'cs6400'
#app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.config['MYSQL_DATABASE_HOST'] = 'mysql' #mysql is the name of the docker container
mysql.init_app(app)


@app.route("/")
def hello():
    visits = "<i>cannot connect to Redis, counter disabled</i>"

    html = "<h3>Hello {name}!</h3>" \
           "<b>Hostname:</b> {hostname}<br/>" \
           "<b>Visits:</b> {visits}" \
            "<a href='/myindex'>Load from DB </a>"
    return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname(), visits=visits)


@app.route("/myindex")
def myindex():
    cursor = mysql.connect().cursor()
    cursor.execute("SELECT * from Persons")
    data = cursor.fetchall()

    return render_template('index.html', data=data)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
