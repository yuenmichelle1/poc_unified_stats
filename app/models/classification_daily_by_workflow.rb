class ClassificationDailyByWorkflow < ApplicationRecord
    self.table_name = 'classification_daily_by_workflow'
    attribute :classification_count, :integer

    def readonly?
        true
    end
end