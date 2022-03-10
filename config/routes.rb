Rails.application.routes.draw do
  get 'home/index'
  get 'home/show'
  get 'home/index'
  get 'home/show--force'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :home, only: [:index]
end
