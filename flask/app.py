import sys
import platform
from subprocess import check_output

import flask
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    kwargs = {}
    if sys.version_info.major == 3:
        kwargs.update(encoding='utf8')
    uwsgi_ver = check_output(['uwsgi', '--version'], **kwargs)
    return "it's work. Python-{} Flask-{} uWSGI-{}".format(
        platform.python_version(),
        flask.__version__,
        uwsgi_ver.strip())
