<html>
  <head>
    <link href="/static/style.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <div class="content">
      <div class="banner">
	<h2>Pandora Bar</h2>
      </div>
      
      <div class="content">
	<div class="login_form">
	  <form action="/auth" method="POST">
	    
	    <div class="email_input">
	      <input type="text" name="email" placeholder="Email"/>
	    </div>
	    <div class="password_input">
	      <input type="password" name="password" placeholder="Password"/>
	    </div>
	    <div class="login_button">
	      <input type="submit" value="Login">
	    </div>
	  </form>
	</div>

	% if error == "auth":
        <div class="auth_error">Invalid login</div>
	% end
      </div>
    </div>
  </body>
</html>
