class ClassificationEvent < ApplicationRecord
    scope :last_year, -> { where('event_time > ?', 1.year.ago) }
    scope :last_month, -> { where('event_time > ?', 1.month.ago) }
    scope :last_week, -> { where('event_time > ?', 1.week.ago) }
    scope :last_hour, -> { where('event_time > ?', 1.hour.ago) }
    scope :yesterday, -> { where('DATE(event_time) = ?', 1.day.ago.to_date) }
    scope :today, -> { where('DATE(event_time) = ?', Date.today) }
end