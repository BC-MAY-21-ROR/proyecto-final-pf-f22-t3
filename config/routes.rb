Rails.application.routes.draw do
  devise_for :users
  # devise_for :users
  root to: "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :users, only: [:show, :edit, :update]

  get "/cheat", to: "minigames#cheat"
  get "/spin", to: "minigames#spin"

  get "/slotmachine", to: "minigames#slotmachine_show"
  get "/horsesrace", to: "minigames#horsesrace_show"
  get "/mines", to: "minigames#mines_show"
  get "/spaceship", to: "minigames#spaceship_show"

  get "/getreward", to: "home#get_reward"
end
