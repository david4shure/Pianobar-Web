from bottle import *
import subprocess

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
        response.set_cookie("pid", str(proc.pid))
        print "ID: " + str(proc.pid)
        redirect("/home")
    else:
        proc.terminate()
        proc.wait()
        redirect("/login/auth")

@get('/home')
def home():
    if request.get_cookie("username") and request.get_cookie("password"):
        ps_aux = subprocess.Popen("ps aux | grep pianobar", stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        output = ps_aux.stdout.readlines()
        return template("home", ps_aux=output)
    else:
        redirect("/login")

@post('/logout')
def logout():
    proc = subprocess.Popen("kill " + request.get_cookie("pid"), shell=True)
    proc.wait()
    response.set_cookie("username", "")
    response.set_cookie("password", "")
    response.set_cookie("pid", "")
    redirect("/login")

run(host="localhost", port=8080, debug=True)
