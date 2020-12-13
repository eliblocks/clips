require 'rails_helper'

RSpec.describe WebhooksController, type: :request do
  let!(:video) { create(:video, mux_playback_id: "iaMFNpsbjEgCdSfMHhS3hQZ2NoNTIHP3") }

  let(:params) do

    {
      "type": "video.asset.ready",
      "data": {
        "tracks": [
          {
            "type": "video",
            "max_width": 1920,
            "max_height": 1080,
            "max_frame_rate": 29.97,
            "id": "Q3EwDWpcl00k01kVAcDNunFi00glh302XChg",
            "duration": 13.346667
          }
        ],
        "status": "ready",
        "playback_ids": [
          {
            "policy": "signed",
            "id": "iaMFNpsbjEgCdSfMHhS3hQZ2NoNTIHP3"
          }
        ],
        "mp4_support": "none",
        "max_stored_resolution": "HD",
        "max_stored_frame_rate": 29.97,
        "master_access": "none",
        "id": "Way6GDM3aYEoHlJU8m6c0296E73Z201bwm",
        "duration": 13.4134,
        "created_at": 1607880060,
        "aspect_ratio": "16:9"
      }
    }
  end

  describe "#mux" do
    it "sets duration from the webhook payload" do
      uploader = double
      expect(Cloudinary::Uploader).to receive(:upload).and_return(uploader)
      expect(uploader).to receive(:public_id)

      post "/webhooks/mux", params: params

      expect(video.reload.duration).to eq(13)
    end

    context "With a different event type" do
      it "returns success" do
        params["type"] = "video.asset.ready"

        uploader = double
        expect(Cloudinary::Uploader).to receive(:upload).and_return(uploader)
        expect(uploader).to receive(:public_id)

        post "/webhooks/mux", params: params

        expect(response.status).to eq(200)
      end
    end
  end
end
