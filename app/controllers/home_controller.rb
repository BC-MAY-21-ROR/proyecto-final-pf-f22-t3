class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    # puts current_user.last_day.to_date
  end

  def get_reward
    return redirect_to root_url, alert: "you have already got today's reward" if Date.today == current_user.last_day
    
    diferencia = (Date.today - current_user.last_day.to_date).to_i
    current_user.streak = diferencia == 1 ? current_user.streak + 1 : 1
    current_user.last_day = Date.today
    current_user.save

    today_bonus = current_user.streak * 50
    current_user.wallet.coins += today_bonus
    current_user.wallet.save
    redirect_to root_url, notice: "you got #{today_bonus} BrightCoins!"
  end
end
