class AddClassificationsTable < ActiveRecord::Migration[7.0]
   def change
     create_table :classification_events, id: false, primary_key: [:classification_id, :event_time] do |t|
      t.bigint :classification_id
      t.timestamps :event_time, null: false #finished_at
      t.timestamps :event_created_at
      t.bigint :project_id
      t.bigint :workflow_id
      t.bigint :user_id
      t.bigint :user_group_id
      t.float :session_time
     end
  
     execute "SELECT create_hypertable('classification_events', 'event_time');"
   end
end
