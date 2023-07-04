# frozen_string_literal: true

require 'csv'
require 'set'
require 'json'
require '../../config/environment'

# used to upsert classification events coming from panoptes (not kinesis stream)
class PanoptesClassificationUpserter
  def upsert_classifications(classifications)
    classification_events = Set.new
    classifications.each { |classification| classification_events.add(classification_event(classification)) }
    # Feature of Rails 6+, instead of using activerecord-import can use Rails' bulk upsert methods
    ClassificationEvent.upsert_all(classification_events.to_a, nil, false)
  end

  def classification_event(classification)
    {
      classification_id: classification['id'],
      event_time: DateTime.parse(classification['created_at']),
      classification_updated_at: DateTime.parse(classification['updated_at']),
      started_at: started_at(JSON.parse(classification['metadata'])),
      finished_at: finished_at(JSON.parse(classification['metadata'])),
      project_id: classification['project_id'],
      workflow_id: classification['workflow_id'],
      user_id: classification['user_id'],
      session_time: session_time(JSON.parse(classification['metadata'])),
      user_group_ids: user_group_ids(JSON.parse(classification['metadata']))
    }
  end

  def user_group_ids(metadata)
    metadata.fetch('user_group_ids', [])
  end

  def started_at(metadata)
    Time.parse(metadata['started_at'])
  end

  def finished_at(metadata)
    Time.parse(metadata['finished_at'])
  end

  def session_time(metadata)
    finished_at = Time.parse(metadata['finished_at'])
    started_at =  Time.parse(metadata['started_at'])
    diff = finished_at.to_i - started_at.to_i
    diff.to_f
  end
end

csv = File.read('./sample_data/sample_panoptes_classifications.csv')
classification_events = Set.new
upserter = PanoptesClassificationUpserter.new
CSV.foreach('./sample_data/sample_panoptes_classifications.csv', headers: true, liberal_parsing: true) do |row|
  classification = upserter.classification_event(row.to_h)
  classification_events << classification
rescue Exception => e
  puts "MDY114 ERROR WITH #{row.to_h['id']}"
  puts "error #{e}"
end

begin
  classification_events.to_a.each_slice(1000) do |batch|
    ClassificationEvent.upsert_all(
      batch,
      unique_by: %i[classification_id event_time]
    )
  end
rescue StandardError => e
  puts "MDY114 UPSERT ERROR #{e}"
end
