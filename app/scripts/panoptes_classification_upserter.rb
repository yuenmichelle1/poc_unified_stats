# used to upsert classification events coming from panoptes (not kinesis stream)
class PanoptesClassificationUpserter   
    def upsert_classifications(classifications)
        classification_events = Set.new
        classifications.each { |classification| classification_events.add(classification_event(classification))}
        #Feature of Rails 6+, instead of using activerecord-import can use Rails' bulk upsert methods
        ClassificationEvent.upsert_all!(classification_events.to_a)
    end
    
    def classification_event(classification)
        {
            classification_id: classification.id,
            event_time: classification.created_at,
            project_id: classification.project_id,
            workflow_id: classification.workflow_id,
            user_id: classification.user_id,
            session_time: session_time(classification.metadata)
        }
    end

    def session_time(metadata)
        finished_at = classification.metadata.finished_at
        started_at = classification.metadata.started_at
        finished_at - started_at
    end
end