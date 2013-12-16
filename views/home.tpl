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
	% for station in output:
	  <li>{{station[5:-1]}}</li>
	% end
      </div>
    </div>
  </body>
</html>
