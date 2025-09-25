Rails.application.routes.draw do
  # Hauptseite
  root "sessions#new"

  # Routen für die Benutzerregistrierung
  get "/signup", to: "users#new", as: "signup"
  resources :users, only: [ :new, :create ]

  # Routen für die An- und Abmeldung
  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
