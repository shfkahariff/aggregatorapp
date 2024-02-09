Rails.application.routes.draw do
  get 'posts/scrape', to: 'posts#scrape'

  resources :posts, except: :show
  get 'home/index'
  root 'posts#index'

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'
end