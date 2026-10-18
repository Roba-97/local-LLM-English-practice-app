class Message < ApplicationRecord
  MAX_LENGTH = 1000

  belongs_to :chat_room

  enum :role, { user: "user", assistant: "assistant" }, prefix: true, validate: true

  validates :content, presence: true
  validates :content, length: { maximum: MAX_LENGTH }, if: :role_user?

  after_create_commit :broadcast_to_chat_room

  private

  def broadcast_to_chat_room
    broadcast_append_to chat_room, target: "messages"
    broadcast_replace_to chat_room, target: "reply_status", partial: "chat_rooms/reply_status",
                                    locals: { status: role_user? ? :pending : :idle }
  end
end
