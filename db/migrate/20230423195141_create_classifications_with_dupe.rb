class CreateClassificationsWithDupe < ActiveRecord::Migration[7.0]
  def change
    # in this model we allow dupes (the dupes of classifications is 1 for every user group.)
    create_table :classifications_with_dupes, id: false do |t|
      t.bigint :id
      t.timestamp :created_at, null: false
      t.timestamp :updated_at
      t.timestamp :started_at
      t.timestamp :finished_at
      t.bigint :project_id
      t.bigint :workflow_id
      t.bigint :user_id
      t.bigint :user_group_id
      t.float :session_time
    end

    execute "SELECT create_hypertable('classifications_with_dupes', 'created_at');"
  end
end
