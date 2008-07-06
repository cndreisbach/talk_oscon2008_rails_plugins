module Viget
  module ForeignKeyMigrations
    class ForeignKeyDefinition < Struct.new(:on, :references, :actions)
      
      def initialize(base)
        @base = base
      end
      
      def to_s
        @base.build_foreign_key_constraint(on, references, actions)
      end

    end
  end
end