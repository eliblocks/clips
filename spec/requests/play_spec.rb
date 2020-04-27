require 'rails_helper'

RSpec.describe "play" do
  let(:creator) { create(:user) }
  let(:viewer) { create(:user) }
  let(:video) { create(:video, user: creator) }
  before { sign_in(viewer) }

  it "updates user balances" do
    expect(viewer.balance).to eq(6000)
    expect(creator.balance).to eq(6000)

    post "/plays", params: { play: { video_id: video.id, duration: 10 } }

    expect(viewer.reload.balance).to eq(5990)
    expect(creator.reload.balance).to eq(6007)
  end
end
