require "active_agent/providers/ollama_provider"

module OllamaSystemRolePatch
  def cleanup_serialized_request(...)
    super.tap do |hash|
      hash[:messages]&.each do |message|
        message[:role] = "system" if message[:role].to_s == "developer"
      end
    end
  end
end

ActiveAgent::Providers::Ollama::Chat::Transforms.singleton_class.prepend(OllamaSystemRolePatch)
