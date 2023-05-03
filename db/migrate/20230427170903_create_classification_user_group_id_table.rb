# frozen_string_literal: true

class CreateClassificationUserGroupIdTable < ActiveRecord::Migration[7.0]
  def change
    create_table :classification_user_groups, id: false do |t|
      t.bigint :classification_id
      t.timestamp :created_at, null: false
      t.bigint :user_group_id
      t.bigint :project_id
      t.bigint :user_id
      t.float :session_time
    end

    execute "SELECT create_hypertable('classification_user_groups', 'created_at');"
  end
end
