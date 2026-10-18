class ChatRoom < ApplicationRecord
  SITUATION_MAX_LENGTH = 500

  has_many :messages, dependent: :destroy

  enum :level, { beginner: 0, intermediate: 1, advanced: 2 }, default: :beginner, validate: true

  validates :situation, presence: true, length: { maximum: SITUATION_MAX_LENGTH }

  # True while the latest message is from the learner (or the AI has not spoken yet).
  def awaiting_reply?
    last_message = messages.order(:created_at).last
    last_message.nil? || last_message.role_user?
  end

  # Returns the created assistant message, or nil when the AI server is unavailable.
  def generate_reply
    content = ConversationAgent.with(chat_room: self).chat.generate_now.message.content
    messages.create!(role: :assistant, content:)
  rescue ActiveAgent::Providers::Errors::ServiceUnavailable => e
    Rails.logger.error("[ChatRoom] #{e.class}: #{e.message} (cause: #{e.cause&.class})")
    nil
  end
end
