Rails.application.routes.draw do
  devise_for :users

  root 'learnables#overview'
  
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
