require_relative './classes/HorsesGame.rb'

$game1 = Game.new

class HorsesRaceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "horses_race"
    transmit $game1.info
  end

  def receive(data)
    $game1.addBet(current_user, data["bet"]) if data["type"] == "bet"
  end

  def unsubscribed
    stop_stream_from "horses_race"
  end
end
