module      FastCounterConcern
  extend ActiveSupport::Concern

  included do
    # should have access to .table_name here in the class context.
    def fast_counter
      @fast_counter ||= begin
        results = connection.execute("select n_live_tup from pg_stat_user_tables where relname = ?", table_name)&.first
        results["n_live_tup"].tap do |faster_count|
          if faster_count.nil?
            connection.execute("set default_statistics_target to 40")
            connection.execute("analyze #{table_name}")
          end
        end
        fast_counter ||= connection.execute("select n_live_tup from pg_stat_user_tables where relname = ?", klasstable_name)[0]["n_live_tup"]
        (fast_counter.nil? || fast_counter.zero?) ? count : fast_counter
      end
    end
  end
end

