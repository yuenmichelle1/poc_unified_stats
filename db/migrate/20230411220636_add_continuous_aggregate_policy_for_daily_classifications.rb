class AddContinuousAggregatePolicyForDailyClassifications < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    execute <<~SQL
    select add_continuous_aggregate_policy(
      'classification_daily_views',
      start_offset => INTERVAL '3 days',
      end_offset => INTERVAL '1 hour',
      schedule_interval => INTERVAL '1 day'
    );
    SQL
  end
end
