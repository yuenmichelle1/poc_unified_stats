# frozen_string_literal: true

class AddClassificationDailyViews < ActiveRecord::Migration[7.0]
  # we have to disable the migration transaction because creating materialized views within it is not allowed.
  disable_ddl_transaction!
  def change
    execute <<~SQL
      create materialized view classification_daily_views
      with (
        timescaledb.continuous
      ) as
      select
        time_bucket('1d', event_time) as day,
        count(*) as classification_count
      from events_pocs
      where event_type='classification'
      group by day;
    SQL
  end
end
