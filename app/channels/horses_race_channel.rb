require_relative './classes/HorsesGame.rb'

$game1 = HorsesRaceGame.new

class HorsesRaceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "horses_race"
    transmit $game1.info(current_user)
  end

  def receive(data)
    $game1.add_bet(current_user, method(:update_coins), data["bet"]) if data["type"] == "bet"
  end

  def update_coins(coins)
    transmit({type: "updateCoins", data: coins})
  end

  def unsubscribed
    stop_stream_from "horses_race"
  end
end
