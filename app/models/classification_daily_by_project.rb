class ClassificationDailyByProject < ApplicationRecord
    self.table_name = 'classification_daily_by_project'
    attribute :classification_count, :integer

    def readonly?
        true
    end
end