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

class HorsesRaceGame
  def initialize
    @phase = "betsTime"
    @bets = []
    @horses = Array.new(5) {|i| Horse.new i+1}
  end

  def emit(type, data = nil)
    ActionCable.server.broadcast("horses_race", { type:, data: })
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
      @horses.each {|h| h.step}
      emit("updateHorses", @horses)

      @horses.each {|h| 
        next if not h.win?
        game_over(h.num)
        race_timer.kill
      }
    end
  end

  def addBet(user, updateCoins, bet)
    return if @phase != "betsTime"
    return if @bets.any? {|b| b[:user].id == user.id }
    num = bet["num"].to_i
    amount = bet["amount"].to_i
    return if not num.between?(1, 5)
    return if not amount.between?(10, user.wallet.coins)
    user.wallet.remove amount
    @bets.push({user:, num:, amount:, result: nil})
    emit("updateBets", get_bets)
    starting if @bets.size == 1
    updateCoins.call user.wallet.coins
  end
  
  def get_bets
    @bets.collect {|b| {user_name: b[:user].name, num: b[:num], amount: b[:amount], result: b[:result] } }
  end

  def info
    {type: "info", data: {bets: get_bets, phase: @phase, winner: @winner} }
  end

  def game_over(winner)
    @winner = winner
    @phase = "gameOver"
    emit("gameOver", winner)

    @bets.each {|b| 
      if b[:num] == winner
        b[:result] = b[:amount]*3
        b[:user].wallet.add b[:result]
      else
        b[:result] = -b[:amount]
      end
    }

    emit("updateBets", get_bets)
    set_timeout(10) {reset}
  end

  def reset
    @phase = "betsTime"
    @horses.each {|h| h.reset}
    @bets = []
    emit("reset")
  end
end
