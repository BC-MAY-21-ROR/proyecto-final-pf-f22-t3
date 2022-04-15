# frozen_string_literal: true

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

FactoryBot.define do
  user = FactoryBot.create(:user)
  factory :wallet do
    coins { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    user { user }
  end
end
