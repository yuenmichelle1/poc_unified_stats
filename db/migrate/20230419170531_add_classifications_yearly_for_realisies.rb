class AddClassificationsYearlyForRealisies < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  def change
    execute <<~SQL
    create materialized view classification_yearly_views_for_realsies
    with (
      timescaledb.continuous
    ) as
    select
      time_bucket('1 year', day) as year,
      sum(classification_count) as yearly_classification_count
    from classification_daily_views_for_realsies
    group by year;
    SQL
  end
end
