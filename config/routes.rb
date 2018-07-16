Rails.application.routes.draw do
  resources :users
  # get 'users/new'
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  root 'static_pages#home'
  get 'static_pages/home'
  # get 'static_pages/help'
  get '/help', to: 'static_pages#help', as: 'helf'
  # get 'static_pages/about'
  get '/about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'

end
