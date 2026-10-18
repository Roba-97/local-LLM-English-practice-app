class ChatRooms::AssistsController < ApplicationController
  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @assist_request = AssistRequest.new(assist_request_params.merge(level: @chat_room.level))

    if @assist_request.valid?
      @request_id = SecureRandom.uuid
      AssistJob.perform_later(@request_id, @assist_request.message, @assist_request.level)
      render :create
    else
      render :create, status: :unprocessable_entity
    end
  end

  private

  def assist_request_params
    params.expect(assist_request: [ :message ])
  end
end
