class ChatRoomsController < ApplicationController
  def index
    @chat_rooms = ChatRoom.order(created_at: :desc)
  end

  def new
    @chat_room = ChatRoom.new
  end

  def create
    @chat_room = ChatRoom.new(chat_room_params)

    if @chat_room.save
      ReplyJob.perform_later(@chat_room)
      redirect_to @chat_room
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @messages = @chat_room.messages.order(:created_at)
    @message = Message.new
    @assist_request = AssistRequest.new
  end

  private

  def chat_room_params
    params.expect(chat_room: [ :situation, :level ])
  end
end
