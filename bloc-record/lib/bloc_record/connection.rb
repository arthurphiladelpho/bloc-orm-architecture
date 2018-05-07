require 'sqlite3'

module Connection
	def connection
		# A new database object will be initialized the first time connection is called.
			# This object will be used later on to read and write data.
		@connection ||= SQLite3::Database.new(BlocRecord.database_filename)
	end
end