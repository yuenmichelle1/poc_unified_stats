# frozen_string_literal: true

class AddTimescale < ActiveRecord::Migration[7.0]
  def change
    create_table :classification_events, id: false, primary_key: %i[classification_id event_time] do |t|
      t.bigint :classification_id
      t.timestamp :event_time, null: false
      t.timestamp :event_created_at
      t.bigint :project_id
      t.bigint :workflow_id
      t.bigint :user_id
      t.bigint :user_group_id
      t.float :session_time

      t.timestamps
    end

    execute "SELECT create_hypertable('classification_events', 'event_time');"
  end
end
