require_relative './Horse.rb'

def set_interval(delay)
  Thread.new do
    loop do
      sleep delay
      yield
    end
  end
end

def set_timeout(delay)
  timer = Thread.new do
    sleep delay
    yield
    timer.kill
  end
end

# HorsesRaceGame Class
class HorsesRaceGame
  def initialize
    @name = "horses_race"
    @winner = nil
    @phase = "betsTime"
    @bets = []
    @horses = Array.new(5) {|index| Horse.new index+1}
  end

  def emit(type, data = nil)
    ActionCable.server.broadcast(@name, { type:, data: })
  end
  
  def starting
    seconds = 15
    
    seconds_timer = set_interval(1) do
      seconds -= 1
      emit("starting", seconds)
      if seconds == 0
        start
        seconds_timer.kill
      end
    end
  end
  
  def start
    @phase = "running"
    
    race_timer = set_interval(0.3) do
      @horses.each {|horse| 
        horse.step
        next if not horse.win?
        game_over(horse.num)
      }
      emit("updateHorses", @horses)
      race_timer.kill if @phase == "gameOver"
    end
  end

  def add_bet(user, update_coins, bet)
    num, amount = bet.values_at("num", "amount").map(&:to_i)
    return if not is_valid_bet?(user, num, amount)
    wallet = user.wallet
    wallet.remove amount
    @bets.push({user:, num:, amount:, result: nil})
    emit("updateBets", get_bets)
    starting if @bets.size == 1
    update_coins.call wallet.coins
  end

  def is_valid_bet?(user, num, amount)
    return false if @phase != "betsTime"
    return false if @bets.any? {|bet| bet[:user].id == user.id }
    return false if not num.between?(1, 5)
    return false if not amount.between?(10, user.wallet.coins)
    return true
  end
  
  def get_bets
    @bets.collect {|bet| {**bet, user: bet[:user].name} }
  end

  def info(user)
    user_bet = @bets.find {|bet| bet[:user].id == user.id }
    betted = user_bet ? user_bet[:num]: false
    {type: "info", data: {bets: get_bets, phase: @phase, winner: @winner, betted:} }
  end

  def game_over(winner)
    @winner = winner
    @phase = "gameOver"
    emit("gameOver", winner)

    @bets.each {|bet|
      amount = bet[:amount]
      if bet[:num] == winner
        bet[:result] = amount*3
        bet[:user].wallet.add bet[:result]
      else
        bet[:result] = -amount
      end
    }

    emit("updateBets", get_bets)
    set_timeout(10) {reset}
  end

  def reset
    @phase = "betsTime"
    @horses.each {|horse| horse.reset}
    @bets = []
    emit("reset")
  end
end
