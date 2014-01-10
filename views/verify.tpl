<html>
  <head>
    <link href="/static/style.css" rel="stylesheet" type="text/css">
    <link rel="icon" href="/static/favicon.ico" type="image/x-icon">
  </head>
  <body>
    <div class="content">
      <div class="banner" id="login_banner">
	<h2>Pandora Bar</h2>
      </div>
      
      <div class="kill_prompt">
	There is already a pianobar process running. Would you like to kill it?
      </div>
      <div class="offending_process">
	{{output}}
      </div>
      
      <form action="/kill" method="POST">
	<input type="hidden" name="PID" value="{{output[1]}}">
	<button type="submit" class="change_station_button" id="kill_proc">Kill</button>
      </form>

      </div>
  </body>
</html>
