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
        <h1>Piano Bar</h1>
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
                <h1 class="title">{{ current_station }} Radio</h1>
              </section>
            </nav>

            <aside class="left-off-canvas-menu">
              <ul class="off-canvas-list">
                <li><label>Stations:</label></li>
              % for station in user_stations:
                % if station.name == current_station:
                <li><a href="#">{{ station.name }}</a></li>
                % else:
                <li><a href="/home/{{ station.identifier }}">{{ station.name }}</a></li>
                % end
              % end
              </ul>
            </aside>

            <section class="main-section panel">
              <h4><span id="title">{{ now_playing["artist"] }} - {{ now_playing["track"] }}</h4>
              <div class="row">
                <div class="medium-3 columns show-for-medium-up">
                  <img src="http://placehold.it/300x300">
                </div>
                <div class="medium-9 columns">
                  <p>Tempor McSweeney's Echo Park quis polaroid kale chips. Sustainable quinoa officia, anim art party keytar Bushwick hashtag delectus 90's wayfarers ugh artisan pour-over cred. Scenester raw denim laboris proident, hoodie irony sint Odd Future leggings Carles consequat sunt polaroid id. Accusamus Echo Park kogi aesthetic church-key laboris. Odio ethical distillery, bespoke synth flexitarian YOLO. Eu meh lo-fi, occaecat delectus fixie small batch. Consectetur bitters non flannel aliqua vero.</p>
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
          if ( track != data.track ) {
            $('#title').html(data.artist + ' - ' + data.track)
          }
        });
      }

      var checker = window.setInterval(now_playing, 1000);
    </script>

  </body>
</html>
