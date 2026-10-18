class Translation
  include ActiveModel::Model
  include ActiveModel::Attributes

  MAX_LENGTH = 1000

  attribute :source_text, :string

  attr_reader :translated_text

  validates :source_text, presence: true, length: { maximum: MAX_LENGTH }

  def translate
    return false if invalid?

    @translated_text = TranslateAgent.with(message: source_text).translate.generate_now.message.content
    true
  rescue ActiveAgent::Providers::Errors::ServiceUnavailable => e
    Rails.logger.error("[Translation] #{e.class}: #{e.message} (cause: #{e.cause&.class})")
    errors.add(:base, "翻訳サーバーに接続できませんでした。しばらくしてから再度お試しください。")
    false
  end
end
