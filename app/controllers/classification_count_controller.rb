# frozen_string_literal: true

class ClassificationCountController < ApplicationController
  def query
    interval = params[:interval] # if not given then return the count
    # if given then bucket by.
    start_date = params[:start_date]
    end_date = params[:end_date]
    # user_id = []
    # workflow_id = []
    # project_id =[]
    # user_group_id = []
    classification_count = []
    where_clause = ''

    if interval == 'year' && params[:project_id].nil? && params[:workflow_id].nil? && params[:user_id].nil? && params[:user_group_id].nil?
      where_clause += "year > '#{start_date}'" if start_date
      where_clause += ' and ' if start_date && end_date
      where_clause += "year < '#{end_date}'" if end_date
      classification_count = if start_date || end_date
                               ClassificationYearlyCount.select('year AS period, yearly_classification_count AS count').where(where_clause)
                             else
                               ClassificationYearlyCount.select('year AS period, yearly_classification_count AS count').all
                             end
    end

    # example query
    # ClassificationEvent.select(
    #     "time_bucket('#{time_bucket}', event_time) AS period, count(*)"
    #     )
    #     .group("period")
    #     .where(**query_filters)
    #     .where("event_time >= NOW() - INTERVAL ?", window)
    #

    render json: {
      message: classification_count
    }
  end
end
