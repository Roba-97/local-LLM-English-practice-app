module ChatRoomsHelper
  LEVEL_LABELS = { "beginner" => "初級", "intermediate" => "中級", "advanced" => "上級" }.freeze

  def level_label(level)
    LEVEL_LABELS.fetch(level)
  end
end
