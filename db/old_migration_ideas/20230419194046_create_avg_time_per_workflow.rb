class CreateAvgTimePerWorkflow < ActiveRecord::Migration[7.0]
  #we have to disable the migration transaction because creating materialized views within it is not allowed.
  disable_ddl_transaction!
  def change
    execute <<~SQL
    create materialized view avg_workflow_session_time
    as
    select
      workflow_id,
      project_id,
      AVG(session_time) as avg_classification_time
    from classification_events srt
    where session_time > 0 AND session_time < 60
    group by workflow_id, project_id;
    SQL
  end
end
