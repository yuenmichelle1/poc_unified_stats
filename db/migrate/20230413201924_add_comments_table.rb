class AddCommentsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :comments, id: false, primary_key: [:comment_id, :event_time] do |t|
     t.bigint :comment_id
     t.timestamp :event_time, null: false
     t.timestamp :event_created_at
     t.bigint :project_id
     t.bigint :workflow_id
     t.bigint :user_id
     t.bigint :user_group_id
    end
 
    execute "SELECT create_hypertable('comments', 'event_time');"
   end
end
