#poc for benchmarking whether having classificatons dupes per user group vs unique classifications and a secondary "faux join table" that maps classification id to user group id with extra details for corporate stats reporting

# frozen_string_literal: true

class ClassificationsWithDupe < ApplicationRecord
    self.table_name = 'classifications_with_dupes'
  
    def readonly?
      true
    end
end
  