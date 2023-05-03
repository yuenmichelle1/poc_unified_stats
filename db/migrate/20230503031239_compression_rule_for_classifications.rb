# frozen_string_literal: true

class CompressionRuleForClassifications < ActiveRecord::Migration[7.0]
  def change
    # enable table compression
    # add compression policy
    execute <<~SQL
      ALTER TABLE classifications SET (
      timescaledb.compress,
      timescaledb.compress_orderby = 'created_at DESC, classification_id'
      );

      SELECT add_compression_policy('classifications', INTERVAL '3 weeks');
    SQL
  end
end
