class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :wallet
  after_create :create_wallet

  def create_wallet
    build_wallet(coins: 50.00).save
  end
end