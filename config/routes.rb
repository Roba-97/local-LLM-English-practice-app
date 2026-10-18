Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resource :translation, only: %i[new create]
  resources :chat_rooms, only: %i[index new create show]
  root "chat_rooms#index"
end
