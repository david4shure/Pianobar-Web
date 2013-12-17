<html>
  <head>
    <link href="/static/style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <div class="content">
      <div class="banner">
	<h2>Pandora Bar</h2>
      </div>
      
      <div class="logout">
	<form action="/logout" method="POST">
	  <input type="submit" value="Logout">
	</form>
      </div>
      
      <div class="stations">
	% for station in user_stations:
	<div class="station">
	  <div class="station_name">Name: {{station.name}}</div>
	  <div class="station_id">ID: {{station.identifier}}</div>
	</div>
	% end
      </div>
    </div>
  </body>
</html>
