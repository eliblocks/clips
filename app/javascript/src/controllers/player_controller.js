import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "browzableVideo" ]

  sendPlay(playDuration) {
    const videoId = $(".browzable-wrapper").data("videoId");
    let playData = { play: {video_id: videoId, duration: playDuration} }
    let balance = $("#balance").data("balance");
    const request = $.ajax({
      url: "/plays",
      method: "POST",
      data: playData,
      dataType: "html"
    });
    
    request.done(msg => {
      this.updateBalance(balance, playDuration);
      console.log("balance: ", balance);
    });
  }

  updateBalance(balance, playDuration) {
    balance -= playDuration;
    if (balance < 10) {
      window.location.href = "/charges/new";
    }

    $("#balance")[0].innerHTML = Math.round(balance/60);
    $("#logo-balance")[0].innerHTML = Math.round(balance/60);
  }

  connect() {
    const browzableVideo = this.browzableVideoTarget
    const playerInstance = jwplayer(browzableVideo);
    const playDuration = 10
    let counter = 0
    let prevPosition = 0

    playerInstance.setup({
      autostart: "true",
      playlist: [{
        file: $(".browzable-wrapper").data("url"),
        // withCredentials: true
      }]
    });

    jwplayer().on('ready', function() {
      console.log("player ready");
      var playerBalance = $(".minutes-balance")
      
      $(".jw-spacer").after(playerBalance);
      playerBalance.show();
    });
  
    jwplayer().on('viewable', function() {
      $(".video-info-container").show();
    });
  
    //inaccurate timekeeping
    jwplayer().on('time', (time) => {
      counter += time.position - prevPosition;
      prevPosition = time.position;
  
      if (counter > (playDuration + 1) || counter < 0 ) {
        counter = 0
      }
  
      if (counter > playDuration) {
        this.sendPlay(playDuration);
        counter -= playDuration;
      }
    });
  }
}
