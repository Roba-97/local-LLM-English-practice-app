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

  def latest_user_message
    messages.role_user.order(:created_at).last
  end

  # Replies only to the latest learner message. If a newer one arrives (before or during generation),
  # returns nil and leaves the reply to the job for that newer message, which sees the full history.
  # Raises ActiveAgent::Providers::Errors::ServiceUnavailable when the AI server is unavailable.
  def generate_reply(replying_to: nil)
    return if superseded?(replying_to)

    content = ConversationAgent.with(chat_room: self).chat.generate_now.message.content
    return if superseded?(replying_to)

    messages.create!(role: :assistant, content:)
  end

  private

  # Bypass the query cache: newer messages are saved by other requests while the job waits for the AI.
  def superseded?(replying_to)
    self.class.uncached { latest_user_message != replying_to }
  end
end
