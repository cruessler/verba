Rails.application.routes.draw do
  devise_for :users

  root 'learnables#overview'

  resources :learnables, only: [] do
    member do
      patch 'flag'
      put 'flag'
    end
  end

  resources :ratings, only: [ :index, :update ] do
    collection do
      get 'review'
    end
  end
  
  resources :vocabularies, only: [] do
    member do
      get 'select'
    end
  end

  resources :words
  resources :phrases
end
