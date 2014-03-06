Pianobar-Web
============

Web interface for pianobar with album artwork through Last FM, as well as social features such as voting
on the next station to be played.


Installation
============
1. Install pianobar with valid TLS fingerprint (see for the following link to compile and [install pianobar from source](http://technicaltom.wordpress.com/2013/09/12/pianobar_tls_handshake_fix/))
2. Simply clone the repository, and in the Pianobar-Web foler, run python pianobar_web.py.
3. If you wish to change the port to 80, you must change lines 233 and 325 to relect this change.
4. Now you can listen to your pandora music, and control your music from anywhere on your network!

Upcoming
=============
1. More extensive album artwork and artist bio info through Last FM.
2. Implementing social features such as voting on the next station to be played. (done)
3. Will introduce distributed music streaming to any internet browser on the same network as the server
4. Instead of using pianobar, migrate to python-pandora for cleaner code base
    -- https://github.com/02strich/python-pandora
