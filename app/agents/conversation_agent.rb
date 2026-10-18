class ConversationAgent < ApplicationAgent
  HISTORY_LIMIT = 20

  # params: chat_room
  def chat
    chat_room = params[:chat_room]

    prompt(
      messages: chat_room.messages.order(:created_at).last(HISTORY_LIMIT).map { { role: it.role, content: it.content } },
      instructions: {
        template: "chat_instructions",
        locals: { situation: chat_room.situation, level: chat_room.level }
      }
    )
  end

  # params: message, level
  def assist
    prompt(
      params[:message],
      instructions: { template: "assist_instructions", locals: { level: params[:level] } }
    )
  end
end
