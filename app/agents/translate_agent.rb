class TranslateAgent < ApplicationAgent
  def translate
    prompt(params[:message])
  end
end
