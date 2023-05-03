# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_230_419_194_046) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'
  enable_extension 'timescaledb'

  create_table 'classification_events', id: false, force: :cascade do |t|
    t.bigint 'classification_id'
    t.datetime 'event_time', precision: nil, null: false
    t.datetime 'event_created_at', precision: nil
    t.bigint 'project_id'
    t.bigint 'workflow_id'
    t.bigint 'user_id'
    t.bigint 'user_group_id'
    t.float 'session_time'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['event_time'], name: 'classification_events_event_time_idx', order: :desc
  end

  create_table 'comments', id: false, force: :cascade do |t|
    t.bigint 'comment_id'
    t.datetime 'event_time', precision: nil, null: false
    t.datetime 'event_created_at', precision: nil
    t.bigint 'project_id'
    t.bigint 'workflow_id'
    t.bigint 'user_id'
    t.bigint 'user_group_id'
    t.index ['event_time'], name: 'comments_event_time_idx', order: :desc
  end

  create_table 'events', id: false, force: :cascade do |t|
    t.timestamptz 'event_time', null: false
    t.integer 'event_id', null: false
    t.text 'event_type', null: false
    t.text 'event_source', null: false
    t.integer 'project_id'
    t.integer 'workflow_id'
    t.integer 'user_id'
    t.integer 'user_group_id'
    t.integer 'session_time'
    t.index ['event_time'], name: 'events_event_time_idx', order: :desc
  end

  create_table 'events_pocs', id: false, force: :cascade do |t|
    t.bigint 'event_id'
    t.string 'event_type'
    t.string 'event_source'
    t.datetime 'event_time', precision: nil, null: false
    t.datetime 'event_created_at', precision: nil
    t.bigint 'project_id'
    t.bigint 'workflow_id'
    t.bigint 'user_id'
    t.bigint 'user_group_id'
    t.float 'session_time'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['event_time'], name: 'events_poc_event_time_idx', order: :desc
  end

  create_view 'classifications_daily_by_group', sql_definition: <<-SQL
      SELECT _materialized_hypertable_4.day,
      _materialized_hypertable_4.user_group_id,
      _materialized_hypertable_4.count
     FROM _timescaledb_internal._materialized_hypertable_4
    WHERE (_materialized_hypertable_4.day < COALESCE(_timescaledb_internal.to_timestamp(_timescaledb_internal.cagg_watermark(4)), '-infinity'::timestamp with time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, events.event_time) AS day,
      events.user_group_id,
      count(*) AS count
     FROM events
    WHERE ((events.event_type = 'classification'::text) AND (events.event_time >= COALESCE(_timescaledb_internal.to_timestamp(_timescaledb_internal.cagg_watermark(4)), '-infinity'::timestamp with time zone)))
    GROUP BY (time_bucket('P1D'::interval, events.event_time)), events.user_group_id;
  SQL
  create_view 'classifications_daily', sql_definition: <<-SQL
      SELECT _materialized_hypertable_5.day,
      _materialized_hypertable_5.count
     FROM _timescaledb_internal._materialized_hypertable_5
    WHERE (_materialized_hypertable_5.day < COALESCE(_timescaledb_internal.to_timestamp(_timescaledb_internal.cagg_watermark(5)), '-infinity'::timestamp with time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, events.event_time) AS day,
      count(*) AS count
     FROM events
    WHERE ((events.event_type = 'classification'::text) AND (events.event_time >= COALESCE(_timescaledb_internal.to_timestamp(_timescaledb_internal.cagg_watermark(5)), '-infinity'::timestamp with time zone)))
    GROUP BY (time_bucket('P1D'::interval, events.event_time));
  SQL
  create_view 'classification_daily_views', sql_definition: <<-SQL
      SELECT _materialized_hypertable_9.day,
      _materialized_hypertable_9.classification_count
     FROM _timescaledb_internal._materialized_hypertable_9
    WHERE (_materialized_hypertable_9.day < COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(9)), '-infinity'::timestamp without time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, events_pocs.event_time) AS day,
      count(*) AS classification_count
     FROM events_pocs
    WHERE (((events_pocs.event_type)::text = 'classification'::text) AND (events_pocs.event_time >= COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(9)), '-infinity'::timestamp without time zone)))
    GROUP BY (time_bucket('P1D'::interval, events_pocs.event_time));
  SQL
  create_view 'classification_daily_views_for_realsies', sql_definition: <<-SQL
      SELECT _materialized_hypertable_12.day,
      _materialized_hypertable_12.classification_count
     FROM _timescaledb_internal._materialized_hypertable_12
    WHERE (_materialized_hypertable_12.day < COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(12)), '-infinity'::timestamp without time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, classification_events.event_time) AS day,
      count(*) AS classification_count
     FROM classification_events
    WHERE (classification_events.event_time >= COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(12)), '-infinity'::timestamp without time zone))
    GROUP BY (time_bucket('P1D'::interval, classification_events.event_time));
  SQL
  create_view 'classification_yearly_views_for_realsies', sql_definition: <<-SQL
      SELECT _materialized_hypertable_14.year,
      _materialized_hypertable_14.yearly_classification_count
     FROM _timescaledb_internal._materialized_hypertable_14
    WHERE (_materialized_hypertable_14.year < COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(14)), '-infinity'::timestamp without time zone))
  UNION ALL
   SELECT time_bucket('P1Y'::interval, classification_daily_views_for_realsies.day) AS year,
      sum(classification_daily_views_for_realsies.classification_count) AS yearly_classification_count
     FROM classification_daily_views_for_realsies
    WHERE (classification_daily_views_for_realsies.day >= COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(14)), '-infinity'::timestamp without time zone))
    GROUP BY (time_bucket('P1Y'::interval, classification_daily_views_for_realsies.day));
  SQL
  create_view 'classification_daily_by_project', sql_definition: <<-SQL
      SELECT _materialized_hypertable_16.day,
      _materialized_hypertable_16.project_id,
      _materialized_hypertable_16.classification_count
     FROM _timescaledb_internal._materialized_hypertable_16
    WHERE (_materialized_hypertable_16.day < COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(16)), '-infinity'::timestamp without time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, classification_events.event_time) AS day,
      classification_events.project_id,
      count(*) AS classification_count
     FROM classification_events
    WHERE (classification_events.event_time >= COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(16)), '-infinity'::timestamp without time zone))
    GROUP BY (time_bucket('P1D'::interval, classification_events.event_time)), classification_events.project_id;
  SQL
  create_view 'classification_daily_by_workflow', sql_definition: <<-SQL
      SELECT _materialized_hypertable_17.day,
      _materialized_hypertable_17.workflow_id,
      _materialized_hypertable_17.classification_count
     FROM _timescaledb_internal._materialized_hypertable_17
    WHERE (_materialized_hypertable_17.day < COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(17)), '-infinity'::timestamp without time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, classification_events.event_time) AS day,
      classification_events.workflow_id,
      count(*) AS classification_count
     FROM classification_events
    WHERE (classification_events.event_time >= COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(17)), '-infinity'::timestamp without time zone))
    GROUP BY (time_bucket('P1D'::interval, classification_events.event_time)), classification_events.workflow_id;
  SQL
  create_view 'classification_daily_by_group_id', sql_definition: <<-SQL
      SELECT _materialized_hypertable_18.day,
      _materialized_hypertable_18.user_group_id,
      _materialized_hypertable_18.classification_count
     FROM _timescaledb_internal._materialized_hypertable_18
    WHERE (_materialized_hypertable_18.day < COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(18)), '-infinity'::timestamp without time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, classification_events.event_time) AS day,
      classification_events.user_group_id,
      count(*) AS classification_count
     FROM classification_events
    WHERE (classification_events.event_time >= COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(18)), '-infinity'::timestamp without time zone))
    GROUP BY (time_bucket('P1D'::interval, classification_events.event_time)), classification_events.user_group_id;
  SQL
  create_view 'average_session_time_again', materialized: true, sql_definition: <<-SQL
      SELECT srt.workflow_id,
      avg(srt.session_time) AS avg_classification_time
     FROM events_pocs srt
    WHERE ((srt.session_time > (0)::double precision) AND (srt.session_time < (60)::double precision))
    GROUP BY srt.workflow_id;
  SQL
  create_view 'average_session_time', materialized: true, sql_definition: <<-SQL
      SELECT srt.project_id,
      srt.workflow_id,
      avg(srt.session_time) AS avg_classification_time
     FROM events_pocs srt
    WHERE ((srt.session_time > (0)::double precision) AND (srt.session_time < (60)::double precision))
    GROUP BY srt.workflow_id, srt.project_id;
  SQL
  create_view 'avg_workflow_session_time', materialized: true, sql_definition: <<-SQL
      SELECT srt.workflow_id,
      srt.project_id,
      avg(srt.session_time) AS avg_classification_time
     FROM classification_events srt
    WHERE ((srt.session_time > (0)::double precision) AND (srt.session_time < (60)::double precision))
    GROUP BY srt.workflow_id, srt.project_id;
  SQL
end
