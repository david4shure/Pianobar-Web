<html>
  <head>
    <link href="/static/bootstrap.css" rel="stylesheet" type="text/css">
    <link href="/static/bootstrap-theme.css" rel="stylesheet" type="text/css">
    <script src="/static/bootstrap.js"></script>
    <link rel="icon" href="/static/favicon.ico" type="image/x-icon">
  </head>
  <body>

    % if error == "auth":
      <div class="alert alert-danger alert-dismissable">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <strong>Uh oh!</strong> We couldn't log you in. Make sure you've got the right password!
      </div>
    % end

    <div class="container">
      <div class="jumbotron" style="text-align:center;margin-top:60px;padding-bottom:180px;">
        <h1>Pandora Bar</h1>
        <p>Welcome to the Pandora Bar. Log in with your Pandora credentials to get started.</p>

        <form role="form" action="/auth" method="post" style="width:200px;position:fixed;left:50%;margin-left:-100px;">
          <div class="form-group">
            <input type="text" name="email" class="form-control" placeholder="Email Address">
          </div>
          <div class="form-group">
            <input type="password" name="password" class="form-control" placeholder="Password">
          </div>
          <button type="submit" class="btn btn-success">Come on In</button>
        </form>
      </div>
    </div>
  </body>
</html>
