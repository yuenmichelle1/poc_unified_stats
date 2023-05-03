# frozen_string_literal: true

class CaPolicyForWorkflow < ActiveRecord::Migration[7.0]
  def change
    execute <<~SQL
      select add_continuous_aggregate_policy(
        'classification_count_daily_per_project',
        start_offset => INTERVAL '3 days',
        end_offset => INTERVAL '1 hour',
        schedule_interval => INTERVAL '1 day'
      );
    SQL
  end
end
