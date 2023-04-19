class AddCompressionPolicyClassification < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    execute <<~SQL
    SELECT add_compression_policy('classification_events', INTERVAL '3 weeks');
    SQL
  end
end
