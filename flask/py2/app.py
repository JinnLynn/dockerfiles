import platform
from subprocess import check_output

import flask
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    uwsgi_ver = check_output(['uwsgi', '--version'])
    return "it's work. Python-{} Flask-{} uWSGI-{}".format(
        platform.python_version(),
        flask.__version__,
        uwsgi_ver.strip())
