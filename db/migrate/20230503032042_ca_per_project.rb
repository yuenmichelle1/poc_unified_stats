# frozen_string_literal: true

class CaPerProject < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    execute <<~SQL
      create materialized view classification_count_daily_per_project
      with (
        timescaledb.continuous
      ) as
      select
        time_bucket('1d', created_at) as period,
        project_id,
        count(*) as classification_count
      from classifications
      group by period, project_id;
    SQL
  end
end
