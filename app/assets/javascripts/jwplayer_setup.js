$(document).on("turbolinks:load", function() {

  // Embed JWplayer
  var controller = $("body").data("controller");

  if ($('#browzable-video').length === 0) { 
    return;
  }

  var playerInstance = jwplayer("browzable-video");
  var playDuration = 10;
  var counter = 0;
  var prevPosition = 0;
  var balance = $("#balance").data("balance");
  var videoId = $(".browzable-wrapper").data("videoId");
  
  playerInstance.setup({
    autostart: "true",
    playlist: [{
      file: $(".browzable-wrapper").data("url"),
      withCredentials: true
    }]
  });

  jwplayer().on('ready', function() {
    console.log("player ready");
    var playerBalance = $(".minutes-balance")
    
    $(".jw-spacer").after(playerBalance);
    playerBalance.show();
  });

  if (controller === "videos") {
    jwplayer().on('viewable', function() {
      $(".video-info-container").show();
    });
  }

  //inaccurate timekeeping
  jwplayer().on('time', function(time) {
    counter += time.position - prevPosition;
    prevPosition = time.position;

    if (counter > (playDuration + 1) || counter < 0 ) {
      counter = 0
    }

    if (counter > playDuration) {
      sendPlay();
      counter -= playDuration;
    }
  });
 

  //post to server

  function sendPlay() {
    var playData = { play: {video_id: videoId, duration: playDuration} }
    var request = $.ajax({
      url: "/plays",
      method: "POST",
      data: playData,
      dataType: "html"
    });
    
    request.done(function( msg ) {
      updateBalance();
      console.log("balance: ", balance);
    });
    
  }

  function updateBalance () {
    balance -= playDuration;
    if (balance < 10) {
      window.location.href = "/charges/new";
    }

    $("#balance")[0].innerHTML = Math.round(balance/60);
    $("#logo-balance")[0].innerHTML = Math.round(balance/60);
  }

  // // must change if rate changes
  // function displayBal(balance) {
  //   if (balance > 5999) {
  //     return (balance/60/1000).toFixed(2) + 'K'
  //   } else {
  //     return Math.floor(balance/60);
  //   }
  // }

});