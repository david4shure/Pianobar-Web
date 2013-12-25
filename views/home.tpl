<html>
  <head>
    <title>Pandora Bar</title>
    <link href="/static/style.css" rel="stylesheet" type="text/css">

    <script type="text/javascript">

      function ajax_get_json() {
          var hr = new XMLHttpRequest();
          var track = document.getElementById("track");
          var album = document.getElementById("album");
          var artist = document.getElementById("artist");
          hr.open("GET", "current.json", true);
          hr.onreadystatechange = function () {
              if (hr.readyState == 4 && hr.status == 200) {
                  var data = JSON.parse(hr.responseText);
                  if (track.innerHTML != data.track) {
                      track.innerHTML = data.track;
                      album.innerHTML = data.album;
                      artist.innerHTML = data.artist;
                  }
              }
          }

          hr.send(null);
          setTimeout(ajax_get_json, 10000)
      }

    </script>

  </head>
  <body>
    <div class="banner" id="main_banner">
      <h2>Pandora Bar</h2>
      <div class="current_user">{{current_user}}</div>

	<form action="/logout" method="POST">
	  <button type="submit" class="banner_button" id="logout">Logout</button>
	</form>

 	<form action="/up" method="POST">
	  <button type="submit" class="banner_button" id="volume_up">+</button>
	</form>
	
	<form action="/down" method="POST">
	  <button type="submit" class="banner_button" id="volume_down">-</button>
	</form>

	<form action="/shift" method="POST">
	  <button type="submit" class="banner_button" id="change"><strong>{{"||" if music_playing else "▶"}}</strong>
	</form>

	<form action="/skip" method="POST">
	  <button type="submit" class="banner_button" id="skip">>>|</button>
	</form>

	<form action="/thumbs_up" method="POST">
	  <button type="submit" class="banner_button" id="thumbs_up">Love it</button>
	</form>
	
	<form action="/thumbs_down" method="POST">
	  <button type="submit" class="banner_button" id="thumbs_down">Ban it</button>
	</form>
	
    </div>

    <div id="current" class="">
      <div id="artist">{{now_playing["artist"]}}</div>
      <div id="track">{{now_playing["track"]}}</div>
      <div id="album">{{now_playing["album"]}}</div>
    </div>

    <div class="stations">
      % for station in user_stations:
      
        % if station.name == current_station:
          <div class="station" id="current_station">
	    <div class="station_name">{{station.name}}</div>
	  </div>

	% else:
	  <div class="station">
	    <div class="station_name">{{station.name}}</div>
	    <div class="change_station_form">
	      <form action="/home" method="POST">
		<input type="hidden" name="PID" value="{{station.identifier}}">
		<button type="submit" value="Change" class="change_station_button">Change</button>
	      </form>
	    </div>
	  </div>
        % end

      % end
    </div>

    <div class="banner" id="current_station_banner">
      <div id="current_station_text">{{current_station}} Radio</div>
    </div>


    <script type="text/javascript">ajax_get_json();</script>

  </body>
</html>
