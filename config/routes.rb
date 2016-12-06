Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :auctions, shallow: true do
    resources :bids, only: [:create]
    resources :publishings, only: :create
  end
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end
  resources :users, only: [:new, :create], shallow: true do
    resources :bids, only: [:index]
  end
end
