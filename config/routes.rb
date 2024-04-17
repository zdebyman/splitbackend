
Rails.application.routes.draw do
  resources :notes
  resource :users, only: [:create]

  resources :expenses do
    resources :splits, only: [:index, :create]
  end

  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"
end
