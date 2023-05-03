# frozen_string_literal: true

class CaPerWorkflow < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    execute <<~SQL
      create materialized view classification_count_daily_per_workflow
      with (
        timescaledb.continuous
      ) as
      select
        time_bucket('1d', created_at) as period,
        workflow_id,
        count(*) as classification_count
      from classifications
      group by period, workflow_id;
    SQL
  end
end
