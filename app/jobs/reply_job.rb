class ReplyJob < ApplicationJob
  queue_as :default

  # The chat room may be deleted before the job runs.
  discard_on ActiveJob::DeserializationError

  def perform(chat_room)
    return if chat_room.generate_reply

    Turbo::StreamsChannel.broadcast_replace_to(
      chat_room,
      target: "reply_status",
      partial: "chat_rooms/reply_status",
      locals: { status: :failed }
    )
  end
end
