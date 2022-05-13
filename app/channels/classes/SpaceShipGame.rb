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

class SpaceShipGame
  def initialize
    @phase = "betsTime"
    @bets = []
    @pay = 1
    @increment = 0.01
    @cycles = 0
  end

  def emit(type, data = nil)
    ActionCable.server.broadcast("space_ship", { type:, data: })
  end
  
  def starting
    seconds = 5
    
    seconds_timer = set_interval(1) do
      seconds -= 1
      emit("starting", seconds)
      if seconds == 0 #<-
        start
        seconds_timer.kill
      end
    end
  end
  
  def start
    @phase = "flying"
    
    ship_timer = set_interval(0.3) do
      @cycles += 1
      (@increment += 0.01).round(2) if @cycles % 20 == 0
      @pay = (@pay+@increment).round(2)
      emit("updatePayment", @pay)
      if rand(40) == 0 #<-
        explote
        ship_timer.kill
      end
    end
  end

  def add_bet(user, update_coins, bet)
    return if @phase != "betsTime"
    return if @bets.any? {|b| b[:user].id == user.id }
    amount = bet["amount"].to_i
    return if not amount.between?(10, user.wallet.coins)
    user.wallet.remove amount
    @bets.push({user:, amount:, result: nil, left: false})
    emit("updateBets", get_bets)
    update_coins.call user.wallet.coins
    starting if @bets.size == 1
  end

  def left(user, update_coins)
    return if @phase != "flying"
    
    @bets.each {|b| 
      if b[:user].id == user.id
        return false if b[:left]
        win = (b[:amount] * @pay).round(2)
        b[:user].wallet.add win
        update_coins.call b[:user].wallet.coins
        b[:result] = "x#{@pay} +#{win}"
        b[:left] = true
      end
    }

    emit("updateBets", get_bets)
  end
  
  def get_bets
    @bets.collect {|b| {user_name: b[:user].name, amount: b[:amount], result: b[:result] } }
  end

  def info
    {type: "info", data: {bets: get_bets, phase: @phase} }
  end

  def explote
    @phase = "gameOver"
    emit("gameOver")
  
    @bets.each {|b|
      next if b[:left]
      b[:result] = -b[:amount]
    }
    emit("updateBets", get_bets)
    set_timeout(5) {reset}
  end

  def reset
    @phase = "betsTime"
    @bets = []
    @pay = 1
    @increment = 0.01
    @cycles = 0
    emit("reset")
  end
end
