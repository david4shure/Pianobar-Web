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

      <br>
      <b><i>There is already a pianobar process running. Would you like to kill it?</b></i>
      <br>
      <br>
      Process: <span style="color:red;">{{output}}</span>
      
      <form action="/kill" method="POST">
	<input type="hidden" name="PID" value="{{output[1]}}">
	<input type="submit" value="Kill">
      </form>

      </div>
  </body>
</html>
