class ChatRooms::MessagesController < ApplicationController
  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages.new(message_params.merge(role: :user))

    if @message.save
      ReplyJob.perform_later(@chat_room, @message)
      @message = Message.new
      render :create
    else
      render :create, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.expect(message: [ :content ])
  end
end
