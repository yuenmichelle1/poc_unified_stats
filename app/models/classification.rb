# frozen_string_literal: true

class Classification < ApplicationRecord
  self.primary_keys = %i[created_at classification_id]
  validates :classification_id, presence: true
  validates :created_at, presence: true

  scope :last_year, -> { where('created_at > ?', 1.year.ago) }
  scope :last_month, -> { where('created_at > ?', 1.month.ago) }
  scope :last_week, -> { where('created_at > ?', 1.week.ago) }
  scope :last_hour, -> { where('created_at > ?', 1.hour.ago) }
  scope :yesterday, -> { where('DATE(created_at) = ?', 1.day.ago.to_date) }
  scope :today, -> { where('DATE(created_at) = ?', Date.today) }
end
