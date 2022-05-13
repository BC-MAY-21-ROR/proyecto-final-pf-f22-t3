class MinesChannel < ApplicationCable::Channel
  def subscribed
    puts "--------------------hola--------------------"
  end

  def receive(data)
    start if data["type"] == "start"
    leave if data["type"] == "leave"
    flip(data["num"]) if data["type"] == "flip"
  end

  def start
    @cards = [
      "Boom",
      "Boom",
      "Boom",
      "Boom",
      "Boom",
      "Boom",
      "Boom",
      "Boom",
      "+ 5",
      "+ 5",
      "+ 5",
      "+ 5",
      "+ 5",
      "+ 10",
      "+ 10",
      "+ 10",
      "+ 15 ",
      "+ 15",
      "+ 20",
      "x 1.5",
      "x 1.5",
      "x 2",
      "x 2.5",
      "x 3"
    ].shuffle
    @prize = 10
    @started = true
    current_user.wallet.remove 10
    transmit({type: "start", data: current_user.wallet.coins})
  end

  def flip(num)
    return if not @started
    back = @cards[num]
    if back == "Boom"
      finish
    else 
      ope, num2 = back.split(" ")
      @prize += num2.to_i if ope == "+"
      @prize *= num2.to_f if ope == "x"
    end
    transmit({type: "flip", data: {back:, num:, prize: @prize}})
  end

  def leave
    return if not @started
    current_user.wallet.add @prize
    transmit({ type: "leave", data: current_user.wallet.coins })
  end

  def finish
    @started = false
  end

  def unsubscribed
    leave
    puts "--------------------adios--------------------"
  end
end
