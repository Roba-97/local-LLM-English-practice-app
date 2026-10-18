Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :chat_rooms, only: %i[index new create show] do
    resource :assist, only: :create, module: :chat_rooms
    resources :messages, only: :create, module: :chat_rooms
  end
  root "chat_rooms#index"
end
