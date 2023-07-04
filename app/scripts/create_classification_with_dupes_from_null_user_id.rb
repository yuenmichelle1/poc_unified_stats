# frozen_string_literal: true

require 'set'
require 'json'
require '../../config/environment'

def classification_with_dupe(classification)
  {
    id: classification.classification_id,
    created_at: classification.created_at,
    updated_at: classification.updated_at,
    started_at: classification.started_at,
    finished_at: classification.finished_at,
    project_id: classification.project_id,
    workflow_id: classification.workflow_id,
    user_id: classification.user_id,
    user_group_id: nil,
    session_time: classification.session_time
  }
end

classification_with_dupes = Set.new
begin
  classifications = Classification.where(user_id: nil)
  classifications.each { |classification| classification_with_dupes << classification_with_dupe(classification) }
  ClassificationsWithDupes.import!(
    classification_with_dupes.to_a,
    batch_size: 1000
  )
rescue StandardError => e
  puts "MDY114 UPSERT ERROR #{e}"
end
