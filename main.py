from bottle import *
import subprocess

proc = None

@get('/')
def index():
    redirect("/login")

@get('/login')
def login():
    if (request.get_cookie("username") and request.get_cookie("password")):
        redirect("/home")
    else:
        return template("login", error=None)

@get('/login/<error>')
def login_error(error):
    return template("login", error=error)

@get('/static/<filename>')
def serve_static(filename):
    return static_file(filename, root="./static")

@post('/auth')
def authenticate():
    proc = subprocess.Popen("pianobar", stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout = proc.stdout
    proc.stdin.write(request.forms.get("username") + "\n")
    proc.stdin.write(request.forms.get("password") + "\n")
    auth = [stdout.readline() for i in range(0, 4)][-1]
    if auth == "\x1b[2K(i) Login... Ok.\n":
        response.set_cookie("username", request.forms.get("username"))
        response.set_cookie("password", request.forms.get("password"))
        redirect("/home")
    else:
        proc.terminate()
        proc.wait()
        redirect("/login/auth")

@get('/home')
def home():
    if request.get_cookie("username") and request.get_cookie("password"):
        return "Hello, " + request.get_cookie("username")
    else:
        redirect("/login")

run(host="localhost", port=8080, debug=True)
