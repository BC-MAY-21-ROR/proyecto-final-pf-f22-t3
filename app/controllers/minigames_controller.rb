$price_for_pair = [1, 1, 1, 3, 3, 3, 3, 3, 5]
$price_for_tree = [10, 10, 10, 30, 30, 30, 30, 30, 300]

$reel1 = [5, 7, 1, 0, 2, 4, 2, 6, 1, 8, 0, 5, 1, 7, 0, 6, 3, 3, 4, 2]
$reel2 = [1, 0, 3, 3, 8, 2, 1, 2, 6, 5, 0, 7, 7, 4, 6, 4, 1, 2, 5, 0]
$reel3 = [0, 0, 1, 5, 1, 2, 8, 2, 6, 4, 7, 0, 3, 6, 2, 3, 7, 1, 4, 5]

class MinigamesController < ApplicationController
  def spin
    rands = 3.times.map { rand(20) }
    result = [$reel1[rands[0]], $reel2[rands[1]], $reel3[rands[2]] ]
    count = result.tally
    
    price = 0
    if(count.size == 2)
      price = $price_for_pair[count.key(2)]
    elsif(count.size == 1)
      price = $price_for_tree[count.keys[0]]
    end

    current_user.wallet.remove 1
    current_user.wallet.add price if price > 0

  
    render json: {rands: rands, price: price}
  end
end
