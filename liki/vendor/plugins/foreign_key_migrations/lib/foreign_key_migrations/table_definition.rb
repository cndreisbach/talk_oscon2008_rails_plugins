module ActiveRecord #:nodoc:
  module ConnectionAdapters #:nodoc:
    class TableDefinition
      
      attr_accessor :constraints, :name
            
      alias :pre_fk_column :column

      def column(name, type, options = {})
        parse_foreign_key_from_column(name, options)
        pre_fk_column(name, type, options)
      end
      
      def foreign_key(params)
        unless @base.respond_to?(:supports_foreign_keys?) && @base.supports_foreign_keys?
          raise Viget::ForeignKeyMigrations::ForeignKeysNotSupported
        end
        
        unless (params.include?(:on) and params.include?(:references))
          raise ArgumentError 
        end
    
        constraint = Viget::ForeignKeyMigrations::ForeignKeyDefinition.new(@base)
        
        constraint.on = {:table => @name, :column => params[:on]}
        constraint.references = @base.normalize_foreign_key_references(params[:references])
        
        # TODO: Refactor this
        actions = {}
        actions.merge!(:delete => params[:delete]) if params.has_key?(:delete)
        actions.merge!(:update => params[:update]) if params.has_key?(:update)
        
        constraint.actions = actions

        @constraints ||= []
        @constraints << constraint unless @constraints.include? constraint        
      end
      
      def to_sql
        @constraints ||= []
        (@columns + @constraints) * ', '
      end
      
      private
      
      # This is the real magic here.
      # Note that instead of adding a "REFERENCES foo(id)" to a column, we
      # add a constraint in the table definition. This allows us to name the
      # restraint, which means we can find and drop it later.
      def parse_foreign_key_from_column(name, options = {})
        if options.has_key?(:references)
          unless @base.respond_to?(:supports_foreign_keys?) && @base.supports_foreign_keys?
            raise Viget::ForeignKeyMigrations::ForeignKeysNotSupported
          end
   
          # TODO: refactor this
          foreign_key_options = {:on => name, :references => options[:references]}
          foreign_key_options.merge!(:delete => options[:delete]) if options.has_key?(:delete)
          foreign_key_options.merge!(:update => options[:update]) if options.has_key?(:update)
          
          foreign_key foreign_key_options
        end
      end
            
    end
  end
end