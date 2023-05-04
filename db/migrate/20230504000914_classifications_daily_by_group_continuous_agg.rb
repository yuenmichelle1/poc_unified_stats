class ClassificationsDailyByGroupContinuousAgg < ActiveRecord::Migration[7.0]
  # we have to disable the migration transaction because creating materialized views within it is not allowed.
  disable_ddl_transaction!

  def change
    execute <<~SQL
      create materialized view classification_daily_by_group
      with (
        timescaledb.continuous
      ) as
      select
        time_bucket('1d', created_at) as period,
        count(*) as classification_count,
        user_group_id
      from classification_user_groups
      group by period, user_group_id;
    SQL
  end
end
