# frozen_string_literal: true

class ClassificationDailyPerUser < ApplicationRecord
    self.table_name = 'classification_count_daily_per_user'
    attribute :classification_count, :integer
    attribute :user_id, :integer

    # Eg. grab classification count per user
    # sum = ClassificationDailyPerUser.where(user_id:1763386).sum(:classification_count)
  
    def readonly?
      true
    end
  end
  