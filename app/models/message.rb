class Message < ApplicationRecord
  MAX_LENGTH = 1000

  belongs_to :chat_room

  enum :role, { user: "user", assistant: "assistant" }, prefix: true, validate: true

  validates :content, presence: true
  validates :content, length: { maximum: MAX_LENGTH }, if: :role_user?
end
