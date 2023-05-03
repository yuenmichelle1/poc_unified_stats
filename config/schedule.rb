# frozen_string_literal: true

every 1.hour do
  rake 'refreshers:avg_workflow_session_time'
end
