$prize_for_pair = [10, 10, 10, 30, 30, 30, 30, 30, 50]
$prize_for_tree = [100, 100, 100, 300, 300, 300, 300, 300, 3000]

$reel1 = [5, 7, 1, 0, 2, 4, 2, 6, 1, 8, 0, 5, 1, 7, 0, 6, 3, 3, 4, 2]
$reel2 = [1, 0, 3, 3, 8, 2, 1, 2, 6, 5, 0, 7, 7, 4, 6, 4, 1, 2, 5, 0]
$reel3 = [0, 0, 1, 5, 1, 2, 8, 2, 6, 4, 7, 0, 3, 6, 2, 3, 7, 1, 4, 5]

class MinigamesController < ApplicationController
  def spin
    return if current_user.wallet.coins <= 0
    rands = 3.times.map { rand(20) }
    # rands = [9, 4, 6]
    result = [$reel1[rands[0]], $reel2[rands[1]], $reel3[rands[2]] ]
    count = result.tally
    
    prize = 0
    if(count.size == 2)
      prize = $prize_for_pair[count.key(2)]
    elsif(count.size == 1)
      prize = $prize_for_tree[count.keys[0]]
    end

    current_user.wallet.remove 5
    current_user.wallet.add prize if prize > 0
  
    render json: {rands:, prize:, coins: current_user.wallet.coins }
  end

  def cheat
    current_user.wallet.add 5000
    redirect_to root_path
  end
end
