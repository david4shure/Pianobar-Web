# David Shure
# Pandora Bar (web interface for pianobar)
# Built using bottle.py

from bottle import *
from threading import Thread
import subprocess, os, signal, time, urllib

# Global variables
proc = None
stations = {}
music_playing = True
current_station = ""
first_login = True
need_to_refresh_stations = True
caffeine = None
artist = None
track = None
album = None

email = ""
password = ""

# redirects to login
@get('/')
def index():
    redirect("/login")

# checks if we are already logged in
@get('/login')
def login():
    global proc
    if proc is not None:
        redirect("/home")
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
    global proc, email, password
    proc = None
    proc = subprocess.Popen("pianobar", stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if proc is None:
        print "Something went wrong. Proc is none"

    local_email = request.forms.get("email")
    local_password = request.forms.get("password")
    
    # Enter email and password when prompted
    proc.stdin.write(local_email + "\n")
    proc.stdin.write(local_password + "\n")

    auth = [proc.stdout.readline() for i in range(0, 4)][-1]

    proc.stdout.readline() # dicard the line '(i) Get stations..'

    # This is what the login success line looks like
    if auth == "\x1b[2K(i) Login... Ok.\n":
        email = local_email
        password = local_password
        redirect("/verify")
    else:
        # kill the process, it is useless to us
        proc.terminate()
        proc.wait()
        redirect("/login/auth")

# verifies no existing pianobar processes are running 
# besides those that were spawned by this user and prompts
# user to kill any existing pianobar processes
@get('/verify')
def verify():
    global email, password, proc

    if email and password:
        ps_aux = subprocess.Popen("ps aux | grep pianobar", stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        output = ps_aux.stdout.readlines()
        for line in output:
            ps_aux_output = line.split()
            if ps_aux_output[10] == "pianobar" and not ps_aux_output[1] == str(proc.pid):
                ps_aux.terminate()
                ps_aux.wait()
                return template("verify", output=ps_aux_output)

        redirect("/home")
    else:
        redirect("/login")

# home route
@get('/home')
def home():
    global proc, stations, music_playing, current_station, first_login, need_to_refresh_stations, artist, track, album, caffeine

    if caffeine is None:
        caffeine = Thread(target=stay_alive)
        caffeine.start()

    if proc is None:
        redirect("/login")

    if first_login or need_to_refresh_stations:
        stations[email] = parse_stations(read_all(proc.stdout))
        current_station = stations[email][1].name
        proc.stdin.write("1\n")
        need_to_refresh_stations = False

    first_login = False
    
    parse_now_playing(read_all(proc.stdout))

    if artist is not None:
        print "Artist: " + artist + " Track: " + track + " Album: " + album

    now_playing = { "track": track, "artist": artist, "album": album }

    return template("home", user_stations=stations[email], current_user=email, music_playing=music_playing, current_station=current_station, now_playing=now_playing)

@get('/current.json')
def current_track():
    global proc, artist, track, album
    
    parse_now_playing(read_all(proc.stdout))
    return """{ "artist" : "%s", "track" : "%s", "album" : "%s" }""" % (artist, track, album)


# self explainatory, route for changing stations
@get('/home/:station')
def change_station(station):
    global proc, current_station, stations, email, music_playing
    if proc is None:
        redirect("/login")
    new_station = station
    proc.stdin.write("s")
    proc.stdin.write(new_station + "\n")
    current_station = stations[email][int(new_station)].name
    music_playing = True
    redirect("/home")

# decreases volume by two "notches"
@get('/up')
def increase_volume():
    global proc
    if proc is None:
        redirect("/login")
    proc.stdin.write("))")
    redirect("/home")

# increases volume by two "notches"
@get('/down')
def decrease_volume():
    global proc
    if proc is None:
        redirect("/login")
    proc.stdin.write("((")
    redirect("/home")

# skips current track
@get('/skip')
def skip():
    global proc, music_playing
    if proc is None:
        redirect("/login")
    proc.stdin.write("n")
    music_playing = True
    redirect("/home")

@get('/shift')
def playpause():
    global proc, music_playing
    if proc is None:
        redirect("/login")
    music_playing = not music_playing
    proc.stdin.write("p")
    redirect("/home")

@get('/thumbs_up')
def thumbs_up():
    global proc
    if proc is None:
        redirect("/login")
    proc.stdin.write("+")
    redirect("/home")

@get('/thumbs_down')
def thumbs_down():
    global proc, music_playing
    if proc is None:
        redirect("/login")
    proc.stdin.write("-")
    music_playing = True
    redirect("/home")

# kills any existing pianobar process that was already running
@post('/kill')
def kill():
    kill = subprocess.Popen("kill " + request.forms.get("PID"), shell=True)
    kill.wait()
    redirect("/verify")

# logs user out, and terminates the pianobar process spawned by user
@get('/logout')
def logout():
    global proc, first_login, email, password
    stations[email] = []
    email = ""
    password = ""
    first_login = True
    if proc is None:
        redirect("/login")
    else:
        proc.terminate()
        proc.wait()
        proc = None
    redirect("/login")

def stay_alive(): # please
    global proc
    while True:
        try:
            if proc is not None:
                time.sleep(90)
                request = urllib.urlopen("http://0.0.0.0:8080/current.json")

        except Exception, e:
            continue

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
    
def filter_lines(lines):
    for line in lines:
        print line
        
def parse_now_playing(raw_lines):
    global artist, track, album
    if len(raw_lines) > 0 and "\" by \"" in raw_lines[-1] and "\" on \"" in raw_lines[-1]:

        cleaned_up = raw_lines[-1][raw_lines[-1].index("\""):-1]
        split = cleaned_up.replace("\" by \"", " | ").replace("\" on \"", " | ").split(" | ")
        print split
        track = split[0].replace("\"", "")
        artist = split[1].replace("\"", "")
        album = split[2]

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

    # not very clever (God awful) use of not regexes
    def parse(self, station_string):
        cleaned = station_string[4:-1]
        self.identifier = int(cleaned[cleaned.index("\t"):cleaned.index(")")].strip())
        split_station = cleaned.split()
        if (split_station[1].strip() == "q" and split_station[2]):
            self.name = split_station[2:-1]
        else:
            self.name = split_station[1:-1]
        for i in range(0, len(split_station)):
            # for QuickMix station
            if split_station[i] == "Q":
                self.name = split_station[-1]
                return
        self.name = " ".join(self.name)


run(host="0.0.0.0", port=8080, debug=True)
