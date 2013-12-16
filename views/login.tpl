<html>
  <head>
    <link href="/static/style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <div class="content">
      <div class="banner">
	<h2>Pandora Bar</h2>
      </div>
      
      <div class="login_form">
	<form action="/auth" method="POST">
	  <br>
	  Username <input type="text" name="username" />
	  <br>
	  Password <input type="password" name="password" />
	  <br>
	  <input type="submit" value="Login">
	</form>
      </div>

      % if error == "auth":
        <span style="color:red;">Invalid Login</span>
      % end
	
    </div>
  </body>
</html>
