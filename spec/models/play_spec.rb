require 'rails_helper'

RSpec.describe Play, type: :model do
  let(:viewer) { create(:user) }
  let(:creator) { create(:user) }
  let(:play) { create(:play, user: viewer) }

  describe '#update_balances' do
    it 'updates account balances' do
      play.update_balances
      expect(viewer.balance).to eq(5990)
      expect(play.video.user.balance).to eq(6007)
    end
  end
end
