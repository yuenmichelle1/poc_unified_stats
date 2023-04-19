class AddCaPolicyForYearlyAgg < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    execute <<~SQL
    select add_continuous_aggregate_policy(
      'classification_yearly_views_for_realsies',
      start_offset => INTERVAL '1 year',
      end_offset => NULL,
      schedule_interval => INTERVAL '1 month'
    );
    SQL
  end
end
