# frozen_string_literal: true

class ClassificationDailyByWorkflow < ApplicationRecord
  self.table_name = 'classification_count_daily_per_workflow'

  def readonly?
    true
  end
end
