
require '../../config/environment'
require 'benchmark'

def total_hours_spent_per_user(user_id, period = nil)
    counts_per_workflows = Classification.select("workflow_id, count(*)").where(user_id: user_id).group(:workflow_id)
    avg_times_per_workflows= AverageWorkflowTime.where(workflow_id: counts_per_workflows.pluck(:workflow_id))
    workflow_to_avg_time = {}
    avg_times_per_workflows.each {|avg| workflow_to_avg_time[avg.workflow_id] = avg.avg_classification_time }
    time_spent = 0
    counts_per_workflows.each do |classification_count|
      avg_time_on_workflow = workflow_to_avg_time[classification_count.workflow_id]
      time_spent_on_workflow = classification_count.count * avg_time_on_workflow
      time_spent += time_spent_on_workflow
    end
    time_spent / 60 / 60
end

def total_session_time_per_user(user_id, period = nil)
    #return in hours by /60/60
    Classification.where(user_id: user_id).where('session_time > 0').sum(:session_time) / 60 / 60
end

Benchmark.bmbm do |x|
    x.report('avg') {  total_hours_spent_per_user(368074) }
    x.report('sum') {  total_session_time_per_user(368074)}
end

#84.30226510329318
puts total_hours_spent_per_user(368074)
#SUM 168.34083333333334
puts "SUM #{total_session_time_per_user(368074)}"
#32948 records
puts "TOTAL CLASSIFICATION COUNT FOR THIS USER #{ClassificationDailyPerUser.where(user_id: 368074).sum(:classification_count)}"