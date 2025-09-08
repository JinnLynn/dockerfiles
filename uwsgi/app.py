import platform
import uwsgi    # type: ignore


def app(env, start_response):
    start_response('200 OK', [('Content-Type', 'text/html')])
    uwsgi_version = uwsgi.version.decode()
    python_version = platform.python_version()
    return [f'it\'s work. Python-{python_version} uWSGI-{uwsgi_version}'.encode()]
