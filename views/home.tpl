<html>
  <head>
    <link href="/static/style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <div class="banner">
      <h2>Pandora Bar</h2>
      <div class="current_user">{{current_user}}</div>
      <div class="logout">
	<form action="/logout" method="POST">
	  <input type="submit" value="Logout">
	</form>
      </div>

    </div>


    <div class="stations">
      % for station in user_stations:
      <div class="station">
	<div class="station_name">{{station.name}}</div>
	<div class="change_station">
	  <form action="/home" method="POST">
	    <input type="hidden" name="PID" value="{{station.identifier}}">
	    <input type="submit" value="Change">
	  </form>
	</div>
      </div>
      % end
    </div>
  </body>
</html>
