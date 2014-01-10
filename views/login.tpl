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
	      <button type="submit" class="banner_button">Login</button>
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
