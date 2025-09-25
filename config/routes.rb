Rails.application.routes.draw do
  root "sessions#new"

  # Registrierung
  resources :users, only: [ :new, :create ]

  # Session (Login/Logout)
  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Deine anderen Routen
  get "/debt_projects/index", to: "debt_projects#index", as: :debt_projects_index
end
