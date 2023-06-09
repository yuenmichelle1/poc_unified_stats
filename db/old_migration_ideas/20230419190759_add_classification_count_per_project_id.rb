# frozen_string_literal: true

class AddClassificationCountPerProjectId < ActiveRecord::Migration[7.0]
  # we have to disable the migration transaction because creating materialized views within it is not allowed.
  disable_ddl_transaction!
  def change
    execute <<~SQL
      create materialized view classification_daily_by_project
      with (
        timescaledb.continuous
      ) as
      select
        time_bucket('1d', event_time) as day,
        project_id,
        count(*) as classification_count
      from classification_events
      group by day, project_id;
    SQL
  end
end
