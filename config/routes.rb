Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#index'
  resources :courses, only: [:index, :show] do
    resources :enrollments, only: [:create]
  end
  resources :lessons, only: [:show]
  namespace :instructor do 
    resources :courses, only: [:new, :create, :show] do
      resources :sections, only: [:new, :create]
    end
    resources :sections, only: [] do
      resources :lessons, only: [:new, :create]
    end
    resources :lessons, only: [:update]
  end
end
