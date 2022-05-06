require_relative './classes/SpaceShipGame.rb'

$game2 = SpaceShipGame.new

class SpaceShipChannel < ApplicationCable::Channel
  def subscribed
    stream_from "space_ship"
    transmit $game2.info
  end

  def receive(data)
    $game2.addBet(current_user, method(:updateCoins), data["bet"]) if data["type"] == "bet"
    $game2.left(current_user, method(:updateCoins)) if data["type"] == "left"
  end

  def updateCoins(coins)
    transmit({type: "updateCoins", data: coins})
  end

  def unsubscribed
    stop_stream_from "space_ship"
  end
end
