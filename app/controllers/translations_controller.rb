class TranslationsController < ApplicationController
  def new
    @assist_request = AssistRequest.new
  end

  def create
    @assist_request = AssistRequest.new(assist_request_params)

    if @assist_request.valid?
      @request_id = SecureRandom.uuid
      AssistJob.perform_later(@request_id, @assist_request.message, @assist_request.level)
      render :new
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def assist_request_params
    params.expect(assist_request: [ :message ])
  end
end
