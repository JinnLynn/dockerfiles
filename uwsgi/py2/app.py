import platform
from subprocess import check_output

OUTPUT = 'it\'s work. Python-{} uWSGI-{}\n'.format(
    platform.python_version(),
    check_output(['uwsgi', '--version']).strip())

def app(env, start_response):
    start_response('200 OK', [('Content-Type','text/html')])
    return [OUTPUT.encode('utf-8')]
