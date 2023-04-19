class ClassificationYearlyCount < ApplicationRecord
    self.table_name = 'classification_yearly_views_for_realsies'
    attribute :yearly_classification_count, :float

    scope :last_year, -> { where('year > ?', 1.year.ago) }

    def readonly?
        true
    end
end