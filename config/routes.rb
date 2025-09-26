Rails.application.routes.draw do
  root "sessions#new"

  resources :users, only: [ :new, :create, :show, :edit, :update ]

  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :debt_projects do
    resources :tasks
  end

  resources :activity_logs, only: [:index, :show]
end
