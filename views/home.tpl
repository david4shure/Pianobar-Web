<html>
  <head>
    <link href="/static/style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <div class="content">
      <div class="banner">
	<h2>Pandora Bar</h2>
      </div>
      
      <div class="home_logout">
	<form action="/logout" method="POST">
	  <input type="submit" value="Logout">
	</form>
      </div>

      % for line in ps_aux:
        <p>{{line}}</p>
      % end

      </div>
  </body>
</html>
