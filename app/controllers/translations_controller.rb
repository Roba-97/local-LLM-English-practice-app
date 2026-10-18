class TranslationsController < ApplicationController
  def new
    @translation = Translation.new
  end

  def create
    @translation = Translation.new(translation_params)

    if @translation.translate
      render :new
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def translation_params
    params.expect(translation: [ :source_text ])
  end
end
