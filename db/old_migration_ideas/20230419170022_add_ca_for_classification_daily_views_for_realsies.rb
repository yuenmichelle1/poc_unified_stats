class AddCaForClassificationDailyViewsForRealsies < ActiveRecord::Migration[7.0]
  #Adds ca policy
  disable_ddl_transaction!
  def change
    execute <<~SQL
    select add_continuous_aggregate_policy(
      'classification_daily_views_for_realsies',
      start_offset => INTERVAL '2 days',
      end_offset => NULL,
      schedule_interval => INTERVAL '1 hour'
    );
    SQL
  end
end
