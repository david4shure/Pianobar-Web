from bottle import *
import subprocess

proc = None

@get('/')
def index():
    redirect("/verify")

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
    global proc 
    proc = subprocess.Popen("pianobar", stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout = proc.stdout
    proc.stdin.write(request.forms.get("username") + "\n")
    proc.stdin.write(request.forms.get("password") + "\n")
    auth = [stdout.readline() for i in range(0, 4)][-1]
    if auth == "\x1b[2K(i) Login... Ok.\n":
        response.set_cookie("username", request.forms.get("username"))
        response.set_cookie("password", request.forms.get("password"))
        redirect("/verify")
    else:
        proc.terminate()
        proc.wait()
        redirect("/login/auth")

# verifies no existing pianobar processes are running 
# besides those that were spawned by this user
@get('/verify')
def verify():
    if request.get_cookie("username") and request.get_cookie("password"):
        ps_aux = subprocess.Popen("ps aux | grep pianobar", stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        output = ps_aux.stdout.readlines()
        for line in output:
            process = line.split()
            if process[10] == "pianobar" and not process[1] == str(proc.pid):
                return template("verify", output=process)
        return template("home")
    else:
        redirect("/login")

@post('/kill')
def kill():
    kill = subprocess.Popen("kill " + request.forms.get("PID"), shell=True)
    kill.wait()
    redirect("/verify")

@post('/logout')
def logout():
    global proc
    proc.terminate()
    proc.wait()
    response.set_cookie("username", "")
    response.set_cookie("password", "")
    redirect("/login")

run(host="localhost", port=8080, debug=True)
