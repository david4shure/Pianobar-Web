<html>
  <head>
    <link href="/static/style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <div class="banner">
      <h2>Pandora Bar</h2>
      <div class="current_user">{{current_user}}</div>

	<form action="/logout" method="POST">
	  <div class="logout_button">
	    <input type="submit" value="Logout">
	  </div>
	</form>


    </div>


    <div class="stations">
      % for station in user_stations:
      <div class="station">
	<div class="station_name"><strong>{{station.name}}</strong></div>
	<div class="change_station">
	  <form action="/home" method="POST">
	    <input type="hidden" name="PID" value="{{station.identifier}}">
	    <input type="submit" value="Change" name="station_id">
	  </form>
	</div>
      </div>
      % end
    </div>
  </body>
</html>
