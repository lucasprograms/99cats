Rails.application.routes.draw do
  resource :session, only: ['new', 'create', 'destroy']
  resources :users, only: ['new', 'create', 'show']
  resources :cats
  resources :cat_rental_requests do
    member do
      post 'approve'
      post 'deny'
    end
  end
end
