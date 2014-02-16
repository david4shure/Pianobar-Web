<html>
  <head>
    <title>Pandora Bar</title>

    <link href="/static/foundation.min.css" rel="stylesheet" type="text/css">
    <link href="/static/foundation-glyphicons.css" rel="stylesheet" type="text/css">


    <script type="text/javascript">

      function ajax_get_json() {
          var hr = new XMLHttpRequest();
          var track = document.getElementById("track");
          var album = document.getElementById("album");
          var artist = document.getElementById("artist");
          hr.open("GET", "current.json", true);
          hr.onreadystatechange = function () {
              if (hr.readyState == 4 && hr.status == 200) {
                  var data = JSON.parse(hr.responseText);
                  if (track.innerHTML != data.track) {
                      track.innerHTML = data.track;
                      album.innerHTML = data.album;
                      artist.innerHTML = data.artist;
                  }
              }
          }

          hr.send(null);
          setTimeout(ajax_get_json, 10000)
      }

    </script>

    <style>
      .no-margin {
        margin:0px 0px 0px 0px;
      }
      </style>

  </head>
  <body>

    <!-- header/controls -->
    <div class="row">
      <div class="medium-3 columns">
        <div class="show-for-medium-up" style="height:38px"></div>
        <h1>Piano Bar</h1>
      </div>
      <div class="small-12 medium-7 columns">
        <fieldset>
          <legend>Controls</legend>
          <div class="button-bar">
            <ul class="button-group" style="margin-bottom:0px">
              <li><a href="/shift" class="tiny button no-margin" data-remote="true">
                <span class="gicon-white gicon-play"></span>

                <span class="gicon-white gicon-pause"></a>
                </li>
              <li><a href="/skip" class="tiny button no-margin" data-remote="true">
                <span class="gicon-white gicon-fast-forward"></a>
                </li>
            </ul>
            <ul class="button-group">
              <li><a href="/thumbs_up" class="tiny button no-margin" data-remote="true">
                <span class="gicon-white gicon-ok"></a>
                </li>
              <li><a href="/thumbs_down" class="tiny button no-margin" data-remote="true">
                <span class="gicon-white gicon-remove"></a>
                </li>
            </ul>
            <ul class="button-group">
              <li><a href="/down" class="tiny button no-margin">
                <span class="gicon-white gicon-volume-down"></a>
                </li>
              <li><a href="/up" class="tiny button no-margin" data-remote="true">
                <span class="gicon-white gicon-volume-up"></a>
                </li>
            </ul>
            <ul class="button-group">
              <li><a href="/logout" class="tiny button no-margin">
                <span class="gicon-white gicon-eject"></a>
                </li>
            </ul>
          </div>
        </fieldset>
      </div>
    </div>
    
    <!-- main body -->
    <div class="row">
      <div class="medium-12 columns">
        <div class="off-canvas-wrap">
          <div class="inner-wrap">
             <nav class="tab-bar">
                <section class="left-small">
                  <a class="left-off-canvas-toggle menu-icon" ><span></span></a>
                </section>

                <section class="middle tab-bar-section">
                  <h1 class="title">{{current_station}} Radio</h1>
                </section>
<!-- 
                <section class="right-small">
                  <a class="right-off-canvas-toggle menu-icon" ><span></span></a>
                </section> -->
              </nav>

            <!-- Off Canvas Menu -->
            <aside class="left-off-canvas-menu">
                <!-- whatever you want goes here -->
                <ul>
                  <li><a href="#">Item 1</a></li>
                ...
                </ul>
            </aside>

            <!-- main content goes here -->
            <p>Tempor McSweeney's Echo Park quis polaroid kale chips. Sustainable quinoa officia, anim art party keytar Bushwick hashtag delectus 90's wayfarers ugh artisan pour-over cred. Scenester raw denim laboris proident, hoodie irony sint Odd Future leggings Carles consequat sunt polaroid id. Accusamus Echo Park kogi aesthetic church-key laboris. Odio ethical distillery, bespoke synth flexitarian YOLO. Eu meh lo-fi, occaecat delectus fixie small batch. Consectetur bitters non flannel aliqua vero.</p>

          <!-- close the off-canvas menu -->
          <a class="exit-off-canvas"></a>

          </div>
        </div>
      </div>
    </div>


    <script src="/static/jquery.js"></script>
    <script src="/static/foundation.min.js"></script>
    <script>$(document).foundation();</script>

    <!-- <div class="banner" id="main_banner">
      <h2>Pandora Bar</h2>
      <div class="current_user">{{current_user}}</div>

	<form action="/logout" method="POST">
	  <button type="submit" class="banner_button" id="logout">Logout</button>
	</form>

 	<form action="/up" method="POST">
	  <button type="submit" class="banner_button" id="volume_up">+</button>
	</form>
	
	<form action="/down" method="POST">
	  <button type="submit" class="banner_button" id="volume_down">-</button>
	</form>

	<form action="/shift" method="POST">
	  <button type="submit" class="banner_button" id="change"><strong>{{"||" if music_playing else "▶"}}</strong>
	</form>

	<form action="/skip" method="POST">
	  <button type="submit" class="banner_button" id="skip">>>|</button>
	</form>

	<form action="/thumbs_up" method="POST">
	  <button type="submit" class="banner_button" id="thumbs_up">Love it</button>
	</form>
	
	<form action="/thumbs_down" method="POST">
	  <button type="submit" class="banner_button" id="thumbs_down">Ban it</button>
	</form>
	
    </div>

    <div id="current" class="">
      <div id="artist">{{now_playing["artist"]}}</div>
      <div id="track">{{now_playing["track"]}}</div>
      <div id="album">{{now_playing["album"]}}</div>
    </div>

    <div class="stations">
      % for station in user_stations:
      
        % if station.name == current_station:
          <div class="station" id="current_station">
	    <div class="station_name">{{station.name}}</div>
	  </div>

	% else:
	  <div class="station">
	    <div class="station_name">{{station.name}}</div>
	    <div class="change_station_form">
	      <form action="/home" method="POST">
		<input type="hidden" name="PID" value="{{station.identifier}}">
		<button type="submit" value="Change" class="change_station_button">Change</button>
	      </form>
	    </div>
	  </div>
        % end

      % end
    </div>

    <div class="banner" id="current_station_banner">
      <div id="current_station_text">{{current_station}} Radio</div>
    </div> -->

<!-- 
    <script type="text/javascript">ajax_get_json();</script>
 -->
  </body>
</html>
