# == Schema Information
#
# Table name: wallets
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  coins      :decimal(10, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require'rails_helper'

describe Wallet do
  before :each do
    @wallet = create(:wallet)
  end

  it "is valid with user_id" do
    expect(@wallet).to be_valid
  end

  it "is invalid without a user_id" do
    @wallet.user_id = nil
    expect(@wallet).not_to be_valid
  end

  it "is invalid with negative value in coins" do 
    @wallet.coins = -1
    expect(@wallet).not_to be_valid
  end
end