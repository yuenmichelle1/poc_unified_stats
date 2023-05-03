# frozen_string_literal: true

class ContinuousAggregatePerUserId < ActiveRecord::Migration[7.0]
  # we have to disable the migration transaction because creating materialized views within it is not allowed.
  disable_ddl_transaction!

  def change
    execute <<~SQL
      create materialized view classification_count_daily_per_user
      with (
        timescaledb.continuous
      ) as
      select
        time_bucket('1d', created_at) as period,
        user_id,
        count(*) as classification_count
      from classifications where user_id is not null
      group by period, user_id;
    SQL
  end
end
