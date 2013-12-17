# David SHure
# Pandora Bar (web interface for pianobar)

from bottle import *
import subprocess
import os
import signal

proc = None
stations = []

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
    proc.stdin.write(request.forms.get("username") + "\n")
    proc.stdin.write(request.forms.get("password") + "\n")
    auth = [proc.stdout.readline() for i in range(0, 4)][-1]
    proc.stdout.readline()
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
            ps_aux_output = line.split()
            if ps_aux_output[10] == "pianobar" and not ps_aux_output[1] == str(proc.pid):
                ps_aux.terminate()
                ps_aux.wait()
                return template("verify", output=ps_aux_output)
        proc.stdin.write("1\n")
        redirect("/home")
    else:
        redirect("/login")

# home route
@get('/home')
def home():
    global proc
    global stations
    if len(stations) == 0:
        raw_stations = read_all(proc.stdout)
        stations = parse_stations(raw_stations)
    return template("home", user_stations=stations)


@post('/home')
def change_station():
    global proc


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

def signal_handler(signum, frame):
    raise Exception("! readline() took too long !")

# reads all the lines possible in a file without EOF (e.g. a stream)
def read_all(file_object):
    lines = []
    try:
        signal.signal(signal.SIGALRM, signal_handler)
        while True:
            signal.alarm(1)
            line = file_object.readline()
            lines.append(line)
            signal.alarm(0)
    except Exception, e:
        return lines

def parse_stations(stations_array):
    station_list = []
    for station_string in stations_array:
        cleaned = station_string[4:-1]
        # sometimes the wrong lines are sent to this function
        if "\t" in cleaned:
            station_list.append(Station(station_string))
    return station_list

class Station:
    def __init__(self, station_string):
        self.parse(station_string)

    # not very clever use of not regexes
    def parse(self, station_string):
        cleaned = station_string[4:-1]
        print repr(cleaned)
        self.identifier = int(cleaned[cleaned.index("\t"):cleaned.index(")")].strip())
        split_station = cleaned.split()
        if (split_station[1] == "q"):
            self.name = split_station[2:-1]
        else:
            self.name = split_station[1:-1]
        self.name = " ".join(self.name)


run(host="127.0.0.1", port=8080, debug=True)
