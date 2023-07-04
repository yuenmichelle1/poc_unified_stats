# frozen_string_literal: true

require 'csv'
require 'json'
require '../../config/environment'

# used to upsert classification events coming from talk (not kinesis stream)
class TalkCommentUpserter
  def comment_event(comment)
    {
      comment_id: comment['id'],
      event_time: DateTime.parse(comment['created_at']),
      comment_updated_at: DateTime.parse(comment['updated_at']),
      project_id: comment['project_id'],
      user_id: comment['user_id']
    }
  end
end

comment_events = Set.new
upserter = TalkCommentUpserter.new

CSV.foreach('./sample_data/comments_test.csv', headers: true, liberal_parsing: true) do |row|
  comment = upserter.comment_event(row.to_h)
  comment_events << comment
rescue StandardError => e
  puts "MDY114 ERROR WIT #{row.to_h['id']}"
  puts "error #{e}"
end

begin
  comment_events.to_a.each_slice(1000) do |batch|
    CommentEvent.upsert_all(
      batch,
      unique_by: %i[comment_id event_time]
    )
  end
rescue StandardError => e
  puts "MDY114 UPSERT ERROR #{e}"
end
