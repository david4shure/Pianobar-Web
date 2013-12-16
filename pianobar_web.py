from bottle import *
import subprocess

proc = None

# redirects to login
@get('/')
def index():
    redirect("/login")

# checks if we are already logged in
@get('/login')
def login():
    if (request.get_cookie("username") and request.get_cookie("password")):
        redirect("/verify")
    else:
        return template("login", error=None)

# gets rendered when we have an authenication error with pandora
@get('/login/<error>')
def login_error(error):
    return template("login", error=error)

# serves our static files, like CSS and javascript
@get('/static/<filename>')
def serve_static(filename):
    return static_file(filename, root="./static")

# authenticates credentials with pandora
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
# besides those that were spawned by this user and prompts
# user to kill any existing pianobar processes
@get('/verify')
def verify():
    if request.get_cookie("username") and request.get_cookie("password"):
        ps_aux = subprocess.Popen("ps aux | grep pianobar", stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        output = ps_aux.stdout.readlines()
        global proc
        for line in output:
            process = line.split()
            if process[10] == "pianobar" and not process[1] == str(proc.pid):
                return template("verify", output=process)
        redirect("/home")
    else:
        redirect("/login")


@get('/home')
def home():
    return template("home")

# kills any existing pianobar process that was already running
@post('/kill')
def kill():
    kill = subprocess.Popen("kill " + request.forms.get("PID"), shell=True)
    kill.wait()
    redirect("/verify")

# logs user out, and terminates the pianobar process spawned by user
@post('/logout')
def logout():
    global proc
    proc.terminate()
    proc.wait()
    response.set_cookie("username", "")
    response.set_cookie("password", "")
    redirect("/login")

run(host="localhost", port=8080, debug=True)
