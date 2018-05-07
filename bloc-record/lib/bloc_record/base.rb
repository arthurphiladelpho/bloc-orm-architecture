require 'bloc_record/utility'
require 'bloc_record/schema'
require 'bloc_record/persistence'
require 'bloc_record/selection'
require 'bloc_record/connection'
 
module BlocRecord
  class Base
    include Persistence
    extend Selection
    extend Schema
    extend Connection

 		def initialize(options={})
 			# Transforms all options' keys into strings.
      options = BlocRecord::Utility.convert_keys(options)
      # Goes over each column and 
      self.class.columns.each do |col|
      	# Creates an instace variable getter and setter for each column.
        self.class.send(:attr_accessor, col)
        # Sets the instance variable to the value corresponding to the key in the options hash
        self.instance_variable_set("@#{col}", options[col])
      end
    end

  end
end