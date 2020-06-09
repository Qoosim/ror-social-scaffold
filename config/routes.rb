Rails.application.routes.draw do

  root 'posts#index'
  get 'friendships', to: 'friendships#index'
  patch 'friendships', to: 'friendships#confirm', as: 'confirm'
  delete 'friendships', to: 'friendships#destroy', as: 'notfriend'

  devise_for :users

  resources :users, only: [:index, :show] do
    resources :friendships
  end
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

end
