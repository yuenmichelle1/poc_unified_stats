# frozen_string_literal: true

class CreateAvgTimePerWorkflow < ActiveRecord::Migration[7.0]
  # we have to disable the migration transaction because creating materialized views within it is not allowed.
  disable_ddl_transaction!
  # session time in seconds, exclude sessions of > 75 mins. 75m * 60s/m =4500s
  def change
    execute <<~SQL
      create materialized view avg_workflow_session_time
      as
      select
        workflow_id,
        project_id,
        AVG(session_time) as avg_classification_time
      from classifications srt
      where session_time > 0 AND session_time < 4500
      group by workflow_id, project_id;
    SQL
  end
end
