# frozen_string_literal: true

require 'set'
require 'json'
require '../../config/environment'

def classification_user_group(classification, user_group_id)
  {
    classification_id: classification.classification_id,
    created_at: classification.created_at,
    user_group_id: user_group_id,
    user_id: classification.user_id,
    project_id: classification.project_id,
    session_time: classification.session_time
  }
end

classification_user_groups = Set.new
begin
  classifications = Classification.where.not(user_group_ids: [])
  classifications.each do |classification|
    (0..(classification.user_group_ids.length - 1)).each do |i|
      classification_user_groups << classification_user_group(classification, classification.user_group_ids[i])
    end
  end
  ClassificationUserGroup.import!(
    classification_user_groups.to_a,
    batch_size: 1000
  )
rescue StandardError => e
  puts "MDY114 UPSERT ERROR #{e}"
end
