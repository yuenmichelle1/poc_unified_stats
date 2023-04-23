class AddHypertable < ActiveRecord::Migration[7.0]
  def change
    execute "SELECT create_hypertable('events_pocs', 'event_time');"
  end
end
