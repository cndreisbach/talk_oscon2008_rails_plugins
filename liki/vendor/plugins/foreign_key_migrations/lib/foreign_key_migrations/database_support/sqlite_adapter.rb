module ActiveRecord #:nodoc:
  module ConnectionAdapters #:nodoc:
    
    class SQLiteAdapter

      def add_foreign_key(params)
        # This method does nothing, as SQLite cannot handle adding and
        # dropping foreign keys. They are not enforced in SQLite, so no
        # harm done.
        false
      end
      
      alias :drop_foreign_key :add_foreign_key

    end
    
  end
end