Rails.application.routes.draw do
  root 'static_pages#home'
  get 'static_pages/home'
  # get 'static_pages/help'
  get '/help', to: 'static_pages#help', as: 'helf'
  # get 'static_pages/about'
  get '/about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'

    # 以下の書き方であればrubymineで補完＆定義移動可能
    # get 'static_pages/contact'
end
