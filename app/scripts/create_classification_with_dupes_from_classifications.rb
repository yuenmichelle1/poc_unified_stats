# frozen_string_literal: true

require 'set'
require 'json'
require '../../config/environment'

def classification_with_dupe(classification, user_group_id)
  {
    id: classification.classification_id,
    created_at: classification.created_at,
    updated_at: classification.updated_at,
    started_at: classification.started_at,
    finished_at: classification.finished_at,
    project_id: classification.project_id,
    workflow_id: classification.workflow_id,
    user_id: classification.user_id,
    user_group_id: user_group_id,
    session_time: classification.session_time
  }
end

classification_with_dupes = Set.new
begin
  classifications = Classification.where.not(user_group_ids: [])
  classifications.each do |classification|
    (0..(classification.user_group_ids.length - 1)).each do |i|
        classification_with_dupes << classification_with_dupe(classification, classification.user_group_ids[i])
    end
  end
  ClassificationsWithDupes.import!(
    classification_with_dupes.to_a,
    batch_size: 1000
  )
rescue Exception => e
  puts "MDY114 UPSERT ERROR #{e}"
end
