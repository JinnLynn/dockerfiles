import platform
import sys
from subprocess import check_output



import flask
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    if sys.version_info.major == 2:
        uwsgi_ver = check_output(['uwsgi', '--version'])
    else:
        uwsgi_ver = check_output(['uwsgi', '--version'], encoding='utf8')
    return "it's work. Python-{} Flask-{} uWSGI-{}".format(
        platform.python_version(),
        flask.__version__,
        uwsgi_ver.strip())
