class Classifications < ActiveRecord::Migration[7.0]
  def change
    create_table :classifications, id: false, primary_key: [:id, :created_at] do |t|
      t.bigint :id
      t.timestamp :created_at, null: false
      t.timestamp :updated_at
      t.timestamp :started_at
      t.timestamp :finished_at
      t.bigint :project_id
      t.bigint :workflow_id
      t.bigint :user_id
      t.bigint :user_group_ids, array: true, default: []
      t.float :session_time
     end
  
     execute "SELECT create_hypertable('classifications', 'created_at');"
  end
end

