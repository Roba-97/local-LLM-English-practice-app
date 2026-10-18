class ApplicationAgent < ActiveAgent::Base
  generate_with :ollama, instructions: "You are a helpful assistant."
end
