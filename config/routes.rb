Rails.application.routes.draw do
  devise_for :users

  resources :stocks, :only => [:index, :new, :create, :destroy]

  match '/stockservice' => 'stocks#sservice', :via => :post
  get '/home' => 'stocks#home', :as => 'home'
  match '/guestlog' => 'stocks#guestlog', :as => 'guestlog', :via => :post

  root :to => 'stocks#home'

end
