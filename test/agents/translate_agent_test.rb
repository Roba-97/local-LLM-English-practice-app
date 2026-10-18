require "test_helper"

class TranslateAgentTest < ActiveAgent::TestCase
  test "translate" do
    generation = TranslateAgent.translate
    assert_not_nil generation
    # Test the generation by calling generate_now if needed
    # response = generation.generate_now
  end
end
