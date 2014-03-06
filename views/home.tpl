<html>
  <head>
    <title>Pandora Bar</title>

    <link href="/static/foundation.min.css" rel="stylesheet" type="text/css">
    <link href="/static/foundation-glyphicons.css" rel="stylesheet" type="text/css">

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
        <h2>Pandora Bar</h2>
      </div>
      <div class="small-12 medium-7 columns">
        <fieldset>
          <legend>Controls</legend>
          <div class="button-bar">
            <ul class="button-group" style="margin-bottom:0px">
              <li><a href="/shift" class="tiny button no-margin">
                <span class="gicon-white gicon-play"></span>

                <span class="gicon-white gicon-pause"></a>
                </li>
              <li><a href="/skip" class="tiny button no-margin">
                <span class="gicon-white gicon-fast-forward"></a>
                </li>
            </ul>
            <ul class="button-group">
              <li><a href="/thumbs_up" class="tiny button no-margin">
                <span class="gicon-white gicon-ok"></a>
                </li>
              <li><a href="/thumbs_down" class="tiny button no-margin">
                <span class="gicon-white gicon-remove"></a>
                </li>
            </ul>
            <ul class="button-group">
              <li><a href="/down" class="tiny button no-margin">
                <span class="gicon-white gicon-volume-down"></a>
                </li>
              <li><a href="/up" class="tiny button no-margin">
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

    <div class="small-12 medium-2 columns">
      <fieldset>
	<legend>Station to play next</legend>
	<ul class="side-nav" id="top_stations">
          <div style="float: left;"><b>Station</b></div><div style="float: right;"><b>Votes</b></div>
          <br>
	  <li id="top_station_0"></li>
          <br>
	  <li id="top_station_1"></li>
          <br>
	  <li id="top_station_2"></li>
          <br>
	  <li id="top_station_3"></li>
          <br>
	  <li id="top_station_4"></li>
          <br>
	</ul>
      </fieldset>
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
                <h1 class="title" id="current_station">{{ current_station }} Radio</h1>
              </section>
            </nav>

            <aside class="left-off-canvas-menu">
              <ul class="off-canvas-list">
                <li><label>Stations:</label></li>

		% for station in user_stations:		

                  % if station.name == current_station:
                <li><a href="#">{{ station.name }}</a></li>
                  % else:
		<li><a href="/vote/{{station.identifier}}">{{ station.name }}</a></li>
                  % end
                % end
              </ul>
            </aside>

            <section class="main-section panel">
              <h4><span id="title">{{ now_playing["artist"] }} - {{ now_playing["track"] }} <small>from <i>{{ now_playing["album"] }}</i></small></h4>
              <div class="row">
                <div class="medium-3 columns show-for-medium-up">
                  <img id="album" src="http://placehold.it/300x300">
                </div>
                <div class="medium-9 columns">
                  <p id="bio">Loading...</p>
                </div>
              </div>
          </section>
          <a class="exit-off-canvas"></a>
          </div>
        </div>
      </div>
    </div>

    <!-- js -->
    <script src="/static/jquery.js"></script>
    <script src="/static/foundation.min.js"></script>
    <script>$(document).foundation();</script>

    <script type="text/javascript">
      var track = "{{ now_playing["track"] }}";

      function now_playing() {
        $.getJSON('/current.json', function(data) {
          top_votes(data.votes);
          if ( track != data.track ) {
            $('#title').html(data.artist + ' - ' + data.track + ' <small>from <i>' + data.album + '</i></small>');
            document.getElementById("current_station").innerHTML = data.station + " Radio";
            artist_info(data.artist);
            album_info(data.artist, data.album);
            track = data.track;
          }
        });
      }

      function top_votes(votes) {
          if (votes.length == 0) {
              for (var j = 0; j < 5; j++) {
	          document.getElementById("top_station_" + j).innerHTML = "";
	      }
          }
          for (var i = 0; i < votes.length; i++) {
	    document.getElementById("top_station_" + i).innerHTML = "<div style=\"float:left;\">" + votes[i][0] + "</div><div style=\"float:right;\">" + votes[i][1] + "</div>";
      	  }
      }

      function artist_info(artist) {
        $.getJSON('http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=' + escape(artist) + '&api_key=a0cdf76d44c313ba809c1f1afb312240&format=json', function(data) {
          var bio = data.artist.bio.content.split("\n");
          if (typeof bio[1] != 'undefined') {
            $('#bio').html([bio[1].replace(/(<([^>]+)>)/ig,""), bio[3]].join("<br><br>"));
          } else {
            $('#bio').html("No bio available for this artist.");
          }
        });
      }

      function album_info(artist, album) {
        $.getJSON('http://ws.audioscrobbler.com/2.0/?method=album.getinfo&artist=' + escape(artist) + '&album=' + escape(album) + '&api_key=a0cdf76d44c313ba809c1f1afb312240&format=json', function(data) {
          art = data.album.image[3]['#text'];
          if (typeof art != 'undefined') {
            console.log(art);
            $('#album').attr('src', art);
          } else {
            $('#album').attr('src', "http://placehold.it/300&text=no+album+art+available");
          }
        });
      }

      var checker = window.setInterval(now_playing, 1000);

      artist_info("{{ now_playing['artist'] }}");
      album_info("{{ now_playing['artist'] }}", "{{ now_playing['album'] }}");
    </script>

  </body>
</html>
