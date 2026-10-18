class ReplyJob < ApplicationJob
  queue_as :default

  # The chat room or message may be deleted before the job runs.
  discard_on ActiveJob::DeserializationError

  def perform(chat_room, replying_to = nil)
    chat_room.generate_reply(replying_to:)
  rescue ActiveAgent::Providers::Errors::ServiceUnavailable => e
    Rails.logger.error("[ReplyJob] #{e.class}: #{e.message} (cause: #{e.cause&.class})")
    Turbo::StreamsChannel.broadcast_replace_to(
      chat_room,
      target: "reply_status",
      partial: "chat_rooms/reply_status",
      locals: { status: :failed }
    )
  end
end
