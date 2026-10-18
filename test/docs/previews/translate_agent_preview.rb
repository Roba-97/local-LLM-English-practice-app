# Preview all agent views/prompts templates at http://localhost:3000/active_agent/agents/translate_agent
class TranslateAgentPreview < ActiveAgent::Preview
  # Preview this email at http://localhost:3000/active_agent/agents/translate_agent/translate
  def translate
    TranslateAgent.translate
  end
end
