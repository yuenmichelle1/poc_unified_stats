# frozen_string_literal: true

class CreateClassificationDailyViews < ActiveRecord::Migration[7.0]
  # we have to disable the migration transaction because creating materialized views within it is not allowed.
  disable_ddl_transaction!

  def change
    execute <<~SQL
      create materialized view classification_daily_views
      with (
        timescaledb.continuous
      ) as
      select
        time_bucket('1d', created_at) as period,
        count(*) as classification_count
      from classifications
      group by period;
    SQL
  end
end
