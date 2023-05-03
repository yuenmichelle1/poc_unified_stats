# frozen_string_literal: true

class AverageWorkflowTime < ApplicationRecord
  self.table_name = 'avg_workflow_session_time'
  attribute :avg_classification_time, :float

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
  end

  def readonly?
    true
  end
end
