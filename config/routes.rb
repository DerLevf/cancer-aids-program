# config/routes.rb

Rails.application.routes.draw do
  root "sessions#new"

  resources :users, only: [ :new, :create, :show, :edit, :update ]

  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

resources :debt_projects do
  member do
    # Die member-Route verwendet das TasksController#completed_tasks action
    get 'completed_tasks', to: 'tasks#completed_tasks'
  end
  
  resources :tasks, except: [:index]
end

  resources :activity_logs, only: [:index, :show]
end