class ClassificationCountController < ApplicationController
    def query
        interval = params[:interval] || 'year'
        start_date = params[:start_date]
        end_date = params[:end_date]
        #user_id = []
        #workflow_id = []
        #project_id =[]
        #user_group_id = []
        classification_count = []
        where_clause = ''

        if interval == 'year' && params[:project_id].nil? && params[:workflow_id].nil? && params[:user_id].nil? && params[:user_group_id].nil?
            where_clause += "year > '#{start_date}'" if start_date
            where_clause += ' and ' if start_date && end_date
            where_clause += "year < '#{end_date}'" if end_date
            classification_count = if start_date || end_date
                ClassificationYearlyCount.where(where_clause)
            else
                ClassificationYearlyCount.all
            end
        end

        puts classification_count

        render json: {
            message: classification_count
        }
    end
end