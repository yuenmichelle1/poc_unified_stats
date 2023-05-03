# frozen_string_literal: true

class ClassificationDailyByProject < ApplicationRecord
  self.table_name = 'classification_count_daily_per_project'
  attribute :classification_count, :integer

  def readonly?
    true
  end
end
