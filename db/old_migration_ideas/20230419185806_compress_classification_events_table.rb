class CompressClassificationEventsTable < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    execute <<~SQL
    ALTER TABLE classification_events SET (
    timescaledb.compress,
    timescaledb.compress_orderby = 'event_time DESC'
    );
    SQL
  end
end
