require 'sqlite3'
require 'bloc_record/utility'

module Schema
	def table 
		# Will return the table name.
		BlocRecord::Utility.underscore(name)
	end

	def schema
		# Iterates over the columns in a database 
		# Creates a key-value pair using each column's name and type.
		# The hash containing the key-values pairs is called @schema and will be returned.
		# The result will look something like:
		# i.e. {"id"=>"integer", "name"=>"text", "age"=>"integer"}
    unless @schema
      @schema = {}
      connection.table_info(table) do |col|
        @schema[col["name"]] = col["type"]
      end
    end
    @schema
  end

  def columns
  	# With the schema method we can easily return the table's columns using:
  	schema.keys
  end

  def attributes
  	columns - ["id"]
  end

  def count 
  	# Returns a count of all records in a table.
  	# Here's where the Ruby - SQL connection starts.
  	connection.execute(<<-SQL)[0][0]
       SELECT COUNT(*) FROM #{table}
     SQL
  end
end









