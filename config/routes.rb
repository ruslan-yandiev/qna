Rails.application.routes.draw do

  devise_for :users
  root to: "questions#index"

  resources :questions do
    member do
      post 'voteup'
      post 'votedown'
    end
  	resources :answers, shallow: true, except: :index do
      patch :best, on: :member
      post :voteup, on: :member
      post :votedown, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :rewards, only: :index
end
