require 'sqlite3'
require 'bloc_record/schema'
 
module Persistence

	def self.included(base)
		base.extend(ClassMethods)
	end

	def save
    self.save! rescue false
  end

	def save!
		unless self.id
      self.id = self.class.create(BlocRecord::Utility.instance_variables_to_hash(self)).id
      BlocRecord::Utility.reload_obj(self)
      return true
    end

		fields = self.class.attributes.map { |col| "#{col}=#{BlocRecord::Utility.sql_strings(self.instance_variable_get("@#{col}"))}" }.join(",")
 
    self.class.connection.execute <<-SQL
      UPDATE #{self.class.table}
      SET #{fields}
      WHERE id = #{self.id};
    SQL
 
    true
	end

	module ClassMethods
		# Our create method takes in a hash.
		def create(attrs)
			# We convert the keys into SQL strings.
    	attrs = BlocRecord::Utility.convert_keys(attrs)
    	# We delete the id key-val pair.
    	attrs.delete "id"
    	# We map all values into an array called vals.
    	vals = attributes.map { |key| BlocRecord::Utility.sql_strings(attrs[key]) }
	
    	# We'll insert into the caller's table our values.
    	connection.execute <<-SQL
      	INSERT INTO #{table} (#{attributes.join ","})
      	VALUES (#{vals.join ","});
    	SQL
    	# Create and return a Ruby hash.
    	data = Hash[attributes.zip attrs.values]
    	data["id"] = connection.execute("SELECT last_insert_rowid();")[0][0]
    	new(data)
  	end
  end
end