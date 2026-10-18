class ReplyJob < ApplicationJob
  queue_as :default

  # The chat room may be deleted before the job runs.
  discard_on ActiveJob::DeserializationError

  def perform(chat_room)
    chat_room.generate_reply
  end
end
