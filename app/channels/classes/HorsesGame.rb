require_relative './Horse.rb'

def emit(data)
  ActionCable.server.broadcast("horses_race", data)
end

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

class Game
  def initialize
    @phase = "betsTime"
    @bets = []
    @horses = Array.new(5) {|i| Horse.new i+1}
  end
  
  def starting
    seconds = 15
    
    seconds_timer = set_interval(1) do
      seconds -= 1
      emit({type: "starting", seconds: seconds})
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
      emit({type: "moveHorses", horses: @horses})

      @horses.each {|h| 
      if h.win?
        game_over(h.num)
        race_timer.kill
      end
      }
    end
  end

  def addBet(user, bet)
    return if @phase != "betsTime"
    return if @bets.any? {|b| b[:user].id == user.id }
    num = bet["num"].to_i
    amount = bet["amount"].to_i
    return if not num.between?(1,5)
    return if not amount.between?(10, user.wallet.coins)
    user.wallet.remove amount
    @bets.push({user:, num:, amount:, result: nil})
    emit({type: "updateBets", bets: get_bets})
    starting if @bets.size == 1
  end
  
  def get_bets
    @bets.collect {|b| {user_name: b[:user].name, num: b[:num], amount: b[:amount], result: b[:result] } }
  end

  def info
    {type: "info", bets: get_bets, phase: @phase, winner: @winner }
  end

  def game_over(winner)
    @winner = winner
    @phase = "raceEnd"
    emit({type: "raceEnd", winner: winner})
    set_timeout(10) {reset}
    @bets.each {|b| 
      if b[:num] == winner
        b[:result] = b[:amount]*3
        b[:user].wallet.add b[:result]
      else
        b[:result] = -b[:amount]
      end
    }
    emit({type: "updateBets", bets: get_bets})
  end

  def reset
    @phase = "betsTime"
    @horses.each {|h| h.reset}
    @bets = []
    emit({type: "reset"})
  end
end