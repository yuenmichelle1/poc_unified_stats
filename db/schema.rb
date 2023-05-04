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

ActiveRecord::Schema[7.0].define(version: 2023_05_04_001454) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "timescaledb"

  create_table "classification_user_groups", id: false, force: :cascade do |t|
    t.bigint "classification_id"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "user_group_id"
    t.bigint "project_id"
    t.bigint "user_id"
    t.float "session_time"
    t.index ["created_at"], name: "classification_user_groups_created_at_idx", order: :desc
  end

  create_table "classifications", primary_key: ["classification_id", "created_at"], force: :cascade do |t|
    t.bigint "classification_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil
    t.datetime "started_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.bigint "project_id"
    t.bigint "workflow_id"
    t.bigint "user_id"
    t.bigint "user_group_ids", default: [], array: true
    t.float "session_time"
    t.index ["created_at"], name: "classifications_created_at_idx", order: :desc
  end

  create_table "classifications_with_dupes", id: false, force: :cascade do |t|
    t.bigint "id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil
    t.datetime "started_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.bigint "project_id"
    t.bigint "workflow_id"
    t.bigint "user_id"
    t.bigint "user_group_id"
    t.float "session_time"
    t.index ["created_at"], name: "classifications_with_dupes_created_at_idx", order: :desc
  end


  create_view "classification_daily_views", sql_definition: <<-SQL
      SELECT _materialized_hypertable_9.period,
      _materialized_hypertable_9.classification_count
     FROM _timescaledb_internal._materialized_hypertable_9
    WHERE (_materialized_hypertable_9.period < COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(9)), '-infinity'::timestamp without time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, classifications.created_at) AS period,
      count(*) AS classification_count
     FROM classifications
    WHERE (classifications.created_at >= COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(9)), '-infinity'::timestamp without time zone))
    GROUP BY (time_bucket('P1D'::interval, classifications.created_at));
  SQL
  create_view "classification_count_daily_per_user", sql_definition: <<-SQL
      SELECT _materialized_hypertable_10.period,
      _materialized_hypertable_10.user_id,
      _materialized_hypertable_10.classification_count
     FROM _timescaledb_internal._materialized_hypertable_10
    WHERE (_materialized_hypertable_10.period < COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(10)), '-infinity'::timestamp without time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, classifications.created_at) AS period,
      classifications.user_id,
      count(*) AS classification_count
     FROM classifications
    WHERE (classifications.created_at >= COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(10)), '-infinity'::timestamp without time zone))
    GROUP BY (time_bucket('P1D'::interval, classifications.created_at)), classifications.user_id;
  SQL
  create_view "classification_count_daily_per_workflow", sql_definition: <<-SQL
      SELECT _materialized_hypertable_12.period,
      _materialized_hypertable_12.workflow_id,
      _materialized_hypertable_12.classification_count
     FROM _timescaledb_internal._materialized_hypertable_12
    WHERE (_materialized_hypertable_12.period < COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(12)), '-infinity'::timestamp without time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, classifications.created_at) AS period,
      classifications.workflow_id,
      count(*) AS classification_count
     FROM classifications
    WHERE (classifications.created_at >= COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(12)), '-infinity'::timestamp without time zone))
    GROUP BY (time_bucket('P1D'::interval, classifications.created_at)), classifications.workflow_id;
  SQL
  create_view "classification_count_daily_per_project", sql_definition: <<-SQL
      SELECT _materialized_hypertable_13.period,
      _materialized_hypertable_13.project_id,
      _materialized_hypertable_13.classification_count
     FROM _timescaledb_internal._materialized_hypertable_13
    WHERE (_materialized_hypertable_13.period < COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(13)), '-infinity'::timestamp without time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, classifications.created_at) AS period,
      classifications.project_id,
      count(*) AS classification_count
     FROM classifications
    WHERE (classifications.created_at >= COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(13)), '-infinity'::timestamp without time zone))
    GROUP BY (time_bucket('P1D'::interval, classifications.created_at)), classifications.project_id;
  SQL
  create_view "classifications_daily_by_user_id_per_project", sql_definition: <<-SQL
      SELECT _materialized_hypertable_14.day,
      _materialized_hypertable_14.count,
      _materialized_hypertable_14.user_id,
      _materialized_hypertable_14.project_id
     FROM _timescaledb_internal._materialized_hypertable_14
    WHERE (_materialized_hypertable_14.day < COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(14)), '-infinity'::timestamp without time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, classifications.created_at) AS day,
      count(*) AS count,
      classifications.user_id,
      classifications.project_id
     FROM classifications
    WHERE (classifications.created_at >= COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(14)), '-infinity'::timestamp without time zone))
    GROUP BY (time_bucket('P1D'::interval, classifications.created_at)), classifications.user_id, classifications.project_id;
  SQL
  create_view "classifications_by_user_id_per_project", materialized: true, sql_definition: <<-SQL
      SELECT count(*) AS count,
      classifications.user_id,
      classifications.project_id
     FROM classifications
    WHERE (classifications.user_id IS NOT NULL)
    GROUP BY classifications.user_id, classifications.project_id;
  SQL
  create_view "classification_daily_by_group", sql_definition: <<-SQL
      SELECT _materialized_hypertable_17.period,
      _materialized_hypertable_17.classification_count,
      _materialized_hypertable_17.user_group_id
     FROM _timescaledb_internal._materialized_hypertable_17
    WHERE (_materialized_hypertable_17.period < COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(17)), '-infinity'::timestamp without time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, classification_user_groups.created_at) AS period,
      count(*) AS classification_count,
      classification_user_groups.user_group_id
     FROM classification_user_groups
    WHERE (classification_user_groups.created_at >= COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(17)), '-infinity'::timestamp without time zone))
    GROUP BY (time_bucket('P1D'::interval, classification_user_groups.created_at)), classification_user_groups.user_group_id;
  SQL
  create_view "classification_daily_by_user_group_by_project", sql_definition: <<-SQL
      SELECT _materialized_hypertable_18.period,
      _materialized_hypertable_18.classification_count,
      _materialized_hypertable_18.user_group_id,
      _materialized_hypertable_18.project_id
     FROM _timescaledb_internal._materialized_hypertable_18
    WHERE (_materialized_hypertable_18.period < COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(18)), '-infinity'::timestamp without time zone))
  UNION ALL
   SELECT time_bucket('P1D'::interval, classification_user_groups.created_at) AS period,
      count(*) AS classification_count,
      classification_user_groups.user_group_id,
      classification_user_groups.project_id
     FROM classification_user_groups
    WHERE (classification_user_groups.created_at >= COALESCE(_timescaledb_internal.to_timestamp_without_timezone(_timescaledb_internal.cagg_watermark(18)), '-infinity'::timestamp without time zone))
    GROUP BY (time_bucket('P1D'::interval, classification_user_groups.created_at)), classification_user_groups.user_group_id, classification_user_groups.project_id;
  SQL
end
