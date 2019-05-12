require 'rails_helper'

RSpec.describe Play, type: :model do
  let(:viewer) { create(:account) }
  let(:play) { create(:play, account: viewer) }

  describe '#update_balances' do
    it 'updates account balances' do
      play.update_balances
      expect(viewer.balance).to eq(4990)
      expect(play.video.account.balance).to eq(5007)
    end
  end
end
