class ChatRoom < ApplicationRecord
  SITUATION_MAX_LENGTH = 500

  has_many :messages, dependent: :destroy

  enum :level, { beginner: 0, intermediate: 1, advanced: 2 }, default: :beginner, validate: true

  validates :situation, presence: true, length: { maximum: SITUATION_MAX_LENGTH }
end
