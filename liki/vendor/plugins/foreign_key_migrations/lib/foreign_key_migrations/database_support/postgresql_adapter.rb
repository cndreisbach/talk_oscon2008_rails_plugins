module ActiveRecord #:nodoc:
  module ConnectionAdapters #:nodoc:
    
    class PostgreSQLAdapter
      def build_drop_foreign_key_sql(on, id)
        "ALTER TABLE #{on[:table]} DROP CONSTRAINT " + id
      end
    end
    
  end
end