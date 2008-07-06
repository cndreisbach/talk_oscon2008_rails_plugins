module Viget
  module ForeignKeyMigrations
    module SchemaStatements
      
      class UnsupportedActionOption < StandardError; end
      
      def add_foreign_key(params)   
        raise ArgumentError unless (params.include?(:on) and params.include?(:references))
      
        params = normalize_foreign_key_relations(params)
        references = params[:references]
        on = params[:on]
        actions = params[:actions] || {}
      
        sql = build_add_foreign_key_sql(on, references, actions)
      
        execute sql
      end
    
      def drop_foreign_key(params)
        raise ArgumentError unless (params.include?(:on) and (
          params.include?(:references) or params.include?(:id)))
      
        params = normalize_foreign_key_relations(params)
        params[:id] ||= build_foreign_key_id(params[:on], params[:references])
      
        sql = build_drop_foreign_key_sql(params[:on], params[:id])
        
        execute sql
      end
      
      # Again with the copying.
      # Here I needed the table name in the foreign key in order to name
      # the constraint. This should be high on the list to refactor.
      def create_table(name, options = {})
        table_definition = ActiveRecord::ConnectionAdapters::TableDefinition.new(self)
        table_definition.primary_key(options[:primary_key] || "id") unless options[:id] == false

        # This is the line I added, and I will buy you a cookie if you
        # can figure out a better way to do this.
        table_definition.name = name

        yield table_definition

        if options[:force]
          drop_table(name, options) rescue nil
        end

        create_sql = "CREATE#{' TEMPORARY' if options[:temporary]} TABLE "
        create_sql << "#{name} ("
        create_sql << table_definition.to_sql
        create_sql << ") #{options[:options]}"
        execute create_sql
      end
            
      def build_foreign_key_constraint(on, references, actions)        
        "CONSTRAINT #{build_foreign_key_id(on, references)} FOREIGN KEY " +
          build_foreign_key_columns(on[:column]) + 
          " REFERENCES #{references[:table]}" + 
          build_foreign_key_columns(references[:column]) + 
          build_foreign_key_actions(actions)
      end
            
      def normalize_foreign_key_references(references)
        unless references.kind_of?(Hash)
          references = {:table => references.to_s, :column => ['id']}
        end
        references
      end
                        
      private
      
      def normalize_foreign_key_relations(params)
        params[:references] = normalize_foreign_key_references(params[:references])
        if params[:on]
          unless params[:on].kind_of?(Hash)
            params[:on] = {:table => params[:on].to_s, 
              :column => [params[:references][:table].singularize + "_id"]}
          end
        end
        params
      end      
      
      def build_foreign_key_id(on, references)
        "fk_#{on[:table]}_" + 
          (on[:column].kind_of?(Array) ? on[:column] * '_' : on[:column]).to_s +
          "_#{references[:table]}_" +
          (references[:column].kind_of?(Array) ? references[:column] * '_' : references[:column].to_s)
      end      
      
      def build_add_foreign_key_sql(on, references, actions)
        "ALTER TABLE #{on[:table]} ADD " +
          build_foreign_key_constraint(on, references, actions)
      end
      
      def build_drop_foreign_key_sql(on, id)
        "ALTER TABLE #{on[:table]} DROP FOREIGN KEY " + id
      end
      
      def build_foreign_key_columns(col)
        "(#{col.kind_of?(Array) ? col * ', ' : col})"
      end      

      def format_action_option(option)
        valid_options = [:restrict, :cascade, :set_null, :no_action]
        raise UnsupportedActionOption unless valid_options.include?(option.to_sym)
        option.to_s.gsub('_', ' ').upcase
      end
      
      def build_foreign_key_actions(actions)
        referential_action = ''
        if actions[:delete] || actions[:update]
          actions.each do |action, option|
            referential_action << " ON #{action.to_s.upcase} #{format_action_option(option)}"
          end
        end
        referential_action
      end
      
    end
    
  end
end