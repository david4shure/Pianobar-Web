<html>
  <head>
    <link href="/static/style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <div class="banner">
      <h2>Pandora Bar</h2>
      <div class="current_user">{{current_user}}</div>

	<form action="/logout" method="POST">
	  <button type="submit" class="logout_button">Logout</button>
	</form>


    </div>


    <div class="stations">
      % for i in range(0, 12):
      <div class="station">
	<div class="station_name"><strong>{{user_stations[i].name}}</strong></div>
	<div class="change_station">
	  <form action="/home" method="POST">
	    <input type="hidden" name="PID" value="{{user_stations[i].identifier}}">
	    <div class="change_station_button">
	      <input type="submit" value="Change" name="station_id">
	    </div>
	  </form>
	</div>
      </div>
      % end
    </div>
  </body>
</html>
