import flask
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "it's work. Flask v{}".format(flask.__version__)
