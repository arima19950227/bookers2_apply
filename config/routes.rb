Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "homes#top"
  get '/home/about' => 'homes#about'
  get 'search' => 'searches#search'

  devise_for :users
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update]do
  resources :book_comments, only: [:create, :destroy]
  resource :favorites, only: [:create, :destroy]
  get "search_book" => "books#search_book"
 end

  resources :users, only: [:index,:show,:edit,:update]do
  resource :relationships, only: [:create, :destroy]
  get 'followings' => 'relationships#followings', as: 'followings'
  get 'followers' => 'relationships#followers', as: 'followers'
 end

 resources :messages, only: [:create]
 resources :rooms, only: [:create,:show]
 resources :groups do
  get "join" => "groups#join"
  get "new/mail" => "groups#new_mail"
  get "send/mail" => "groups#send_mail"
 end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
