require'rails_helper'

describe User do
  before :each do
    @user = create(:user)
  end

  it "is valid with email, password and password confirmation" do
    expect(@user).to be_valid
  end

  it "is invalid without a password" do
    @user.password = nil
    expect(@user).not_to be_valid
  end

  it "is invalid without an email address" do 
    user = User.create(password: Faker::Internet.password(min_length: 8))
    expect(user).not_to be_valid
  end

  it "is invalid with a duplicate email address" do
    user = User.create(email: @user.email, password: Faker::Internet.password(min_length: 8))
    expect(user).not_to be_valid
  end

  it "create an associated wallet with 50 coins" do
    expect(@user.wallet.coins).to eq(50)
  end

  it "is valid with a wallet associated" do
    expect(@user.wallet).not_to be_nil
  end
end
