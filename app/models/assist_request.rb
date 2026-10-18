class AssistRequest
  include ActiveModel::Model
  include ActiveModel::Attributes

  MAX_LENGTH = 1000
  LEVELS = %w[beginner intermediate advanced].freeze

  attribute :message, :string
  attribute :level, :string, default: "beginner"

  attr_reader :suggestion

  validates :message, presence: true, length: { maximum: MAX_LENGTH }
  validates :level, inclusion: { in: LEVELS }

  def assist
    return false if invalid?

    @suggestion = ConversationAgent.with(message:, level:).assist.generate_now.message.content
    true
  rescue ActiveAgent::Providers::Errors::ServiceUnavailable => e
    Rails.logger.error("[AssistRequest] #{e.class}: #{e.message} (cause: #{e.cause&.class})")
    errors.add(:base, "AIサーバーに接続できませんでした。しばらくしてから再度お試しください。")
    false
  end
end
