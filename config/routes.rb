
Rails.application.routes.draw do
  resource :users, only: [:create]

  get "/users", to: "users#index"
  get "/users/:user_id/", to: "users#show"

  resources :expenses do
    resources :splits, only: [:index, :create]
  end

  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"

  get "/balances", to: "balances#index"
end
