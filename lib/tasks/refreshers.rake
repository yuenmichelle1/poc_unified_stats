namespace :refreshers do
  desc "Refresh materialized view for average workflow session time"
  task avg_workflow_session_time: :environment do
    AverageWorkflowTime.refresh
  end
end