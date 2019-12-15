Rails.application.routes.draw do
  root 'static_pages#index'
  # get '/auth/:provider/callback', to: 'sessions#create'
  get '/snaplogin', to: "static_pages#snaplogin"
  get '/snapcode', to: "static_pages#snapcode"
end
