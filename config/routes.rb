Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resource :translation, only: %i[new create]
  root "translations#new"
end
