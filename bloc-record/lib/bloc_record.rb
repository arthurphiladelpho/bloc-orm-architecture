module BlocRecord
	# When a user calls BlocRecord.connect_to('data.db'), it will store this file's name for later use.
 	def self.connect_to(filename)
   	@database_filename = filename
 	end

 	# Access to the file's name.
 	def self.database_filename
   	@database_filename
 	end
end