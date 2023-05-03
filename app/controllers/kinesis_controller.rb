# frozen_string_literal: true

class KinesisController < ApplicationController
  skip_before_action :authenticate!
  before_action :require_http_basic_authentication

  def create
    skip_authorization

    comment_events = Set.new
    classification_events = Set.new
    events_json = JSON.parse(params['payload'])

    events_json.each do |event|
      if event.fetch('source') == 'panoptes' && event.fetch('type') == 'classification'
      # classification = ClassificationEvent.new(
      #     classification_id: event.dig('data', 'id'),
      #     event_time: finished_at(payload),
      #     project_id: ,
      #     workflow_id:,
      #     user_id:,
      #     user_group_id:,
      #     session_time:,
      #     created_at:
      #     updated_at:,
      #     started_at:
      # )
      # classification_events.add(classification)
      elsif event.fetch('source') == 'talk' && event.fetch('type') == 'comment'
      # comment = Comment.new()
      # comment_events.add(comment)
      else
        puts 'MDY114 UNKNOWN EVENT'
      end
      # ClassificationEvent.transaction do

      # end
      # Comment.transaction do
      # end
    end
    head :no_content
  end

  private

  def finished_at(payload)
    finished_at = payload.dig('data', 'metadata', 'finished_at')
    DateTime.parse(finished_at)
  end

  def require_http_basic_authentication
    if !has_basic_credentials?(request)
      allow_unauthenticated_request?
    elsif authenticate_with_http_basic { |user, pass| authenticate(user, pass) }
      true
    else
      head :forbidden
    end
  end

  def authenticate(given_username, given_password)
    desired_username = Rails.application.secrets.kinesis[:username]
    desired_password = Rails.application.secrets.kinesis[:password]

    if desired_username.present? || desired_password.present?
      given_username == desired_username && given_password == desired_password
    else
      # If no credentials configured in dev/test, don't require authentication
      allow_unauthenticated_request?
    end
  end

  def allow_unauthenticated_request?
    Rails.env.development? || Rails.env.test?
  end
end
