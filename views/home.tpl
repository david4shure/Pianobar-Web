<html>
  <head>
    <link href="/static/style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <div class="banner">
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

	<form action="/change" method="POST">
	  <button type="submit" class="banner_button" id="change"><strong>{{"||" if music_playing else "▶"}}</strong>
	</form>

	<form action="/skip" method="POST">
	  <button type="submit" class="banner_button" id="skip">>></button>
	</form>

	<form action="/thumbs_up" method="POST">
	  <button type="submit" class="banner_button" id="thumbs_up">Love it</button>
	</form>
	
	<form action="/thumbs_down" method="POST">
	  <button type="submit" class="banner_button" id="thumbs_down">Ban it</button>
	</form>
	
    </div>


    <div class="stations">
      % for station in user_stations:
      <div class="station">
	<div class="station_name"><strong>{{station.name}}</strong></div>
	<div class="change_station_form">
	  <form action="/home" method="POST">
	    <input type="hidden" name="PID" value="{{station.identifier}}">
	    <button type="submit" value="Change" class="change_station_button">Change</button>
	  </form>
	</div>
      </div>
      % end
    </div>
  </body>
</html>
