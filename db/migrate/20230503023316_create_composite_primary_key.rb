# frozen_string_literal: true

class CreateCompositePrimaryKey < ActiveRecord::Migration[7.0]
  def change
    execute <<~SQL
      ALTER TABLE classifications ADD PRIMARY KEY(classification_id, created_at);
    SQL
  end
end
