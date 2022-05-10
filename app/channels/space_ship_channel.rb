require_relative './classes/SpaceShipGame.rb'

$game2 = SpaceShipGame.new

class SpaceShipChannel < ApplicationCable::Channel
  def subscribed
    stream_from "space_ship"
    transmit $game2.info
  end

  def receive(data)
    $game2.add_bet(current_user, method(:update_coins), data["bet"]) if data["type"] == "bet"
    $game2.left(current_user, method(:update_coins)) if data["type"] == "left"
  end

  def update_coins(coins)
    transmit({type: "updateCoins", data: coins})
  end

  def unsubscribed
    stop_stream_from "space_ship"
  end
end
