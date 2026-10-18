# Preview all agent views/prompts templates at http://localhost:3000/active_agent/agents/conversation_agent
class ConversationAgentPreview < ActiveAgent::Preview
  def assist
    ConversationAgent.with(message: "おすすめのコーヒーを聞きたい", level: "beginner").assist
  end
end
