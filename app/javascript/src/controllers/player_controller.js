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
  }

}
