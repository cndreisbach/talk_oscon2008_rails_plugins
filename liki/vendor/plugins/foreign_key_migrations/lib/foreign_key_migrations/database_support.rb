module Viget
  module ForeignKeyMigrations
    
    class ForeignKeysNotSupported < Exception #:nodoc:
    end
    
    module DatabaseSupport
      def supports_foreign_keys?
        true
      end
    end
    
  end
end