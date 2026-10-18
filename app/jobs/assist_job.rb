class AssistJob < ApplicationJob
  queue_as :default

  # The message is user input; keep it out of the job logs.
  self.log_arguments = false

  def perform(request_id, message, level)
    assist_request = AssistRequest.new(message:, level:)
    assist_request.assist

    Turbo::StreamsChannel.broadcast_replace_to(
      "assist", request_id,
      target: "assist_result",
      partial: "chat_rooms/assists/result",
      locals: { assist_request: }
    )
  end
end
