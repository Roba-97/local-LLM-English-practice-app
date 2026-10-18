class TranslationJob < ApplicationJob
  queue_as :default

  # The source text is user input; keep it out of the job logs.
  self.log_arguments = false

  def perform(request_id, source_text)
    translation = Translation.new(source_text: source_text)
    translation.translate

    Turbo::StreamsChannel.broadcast_replace_to(
      "translation", request_id,
      target: "translation_result",
      partial: "translations/result",
      locals: { translation: translation }
    )
  end
end
