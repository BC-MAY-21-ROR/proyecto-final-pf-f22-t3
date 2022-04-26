class MinigamesController < ApplicationController
  def spin

    # reels = [
    #   [5, 7, 1, 0, 2, 4, 2, 6, 1, 8, 0, 5, 1, 7, 0, 6, 3, 3, 4, 2]
    #   [1, 0, 3, 3, 8, 2, 1, 2, 6, 5, 0, 7, 7, 4, 6, 4, 1, 2, 5, 0]
    #   [0, 0, 1, 5, 1, 2, 8, 2, 6, 4, 7, 0, 3, 6, 2, 3, 7, 1, 4, 5]
    # ]

    # win = [9, 4, 6]

    # render json: {result: win}
    render json: {result: 3.times.map { rand(20) }}
  end
end

##
# 20

#0 css         3
#1 html        3
#2 php         3
#3 python      2
#4 ruby        2
#5 javascript  2
#6 java        2
#7 cpp         2
#8 bc          1
      
# 1 bc       267/1000 => 26.7% => 
# 2 php      189/1000 => 18.9% => 
# 2 python    96/1000 =>  9.6% => 
# 2 ruby      96/1000 =>  9.6% => 
# 2 js        96/1000 =>  9.6% => 
# 2 bc        27/1000 =>  2.7% => 
# 3 php       27/1000 =>  2.7% => 
# 3 python     8/1000 =>  0.8% => 
# 3 ruby       8/1000 =>  0.8% => 
# 3 js         8/1000 =>  0.8% => 
# 3 bc         1/1000 =>  0.1% => 

#prob win 82.3%


#10
#1

# 2 php       459/8000 => 5.73% => 1 -----------------
# 2 html      459/8000 => 5.73% => 1
# 2 css       459/8000 => 5.73% => 1
# ---
# 2 python    216/8000 => 2.7% => 3       
# 2 ruby      216/8000 => 2.7% => 3 
# 2 js        216/8000 => 2.7% => 3
# 2 java      216/8000 => 2.7% => 3
# 2 c++       216/8000 => 2.7% => 3 -------------------
# ---
# 2 bc         57/8000 => 0.71% => 5
# --- --- --- --- --- --- --- ---
# 3 php        27/8000 => 0.33% => 10     
# 3 html       27/8000 => 0.33% => 10
# 3 css        27/8000 => 0.33% => 10
# ---
# 3 python      8/8000 => 0.1% => 30 --------------------
# 3 ruby        8/8000 => 0.1% => 30
# 3 js          8/8000 => 0.1% => 30      
# 3 java        8/8000 => 0.1% => 30
# 3 c++         8/8000 => 0.1% => 30
# ---
# 3 bc          1/8000 =>  0.01% => 300 ---------------------

#prob win 32.9%

#1377
#3240
# 285
# 810
#1200
# 300

#7212 => 90.15%


