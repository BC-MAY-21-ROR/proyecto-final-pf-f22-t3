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
class Wallet < ApplicationRecord
  belongs_to :user

  validates :coins, numericality: { greater_than_or_equal_to: 0 }
end
