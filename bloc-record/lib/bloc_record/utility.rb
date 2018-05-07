module BlocRecord
	module Utility
		# Makes underscore to be a class method and not an instance method.
		# Allowing us to run code like this ~> BlocRecord::Utility.underscore('TextLikeThis').
		extend self

		def underscore(camel_cased_word)
			# Replace double colons with a slash.
			str = camel_cased_word.gsub(/::/, '/')
			# Inserts an underscore between any all-caps class prefixes (like acronyms) and other words
			str.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2') 
			# Inserts an underscore between any camelcased words.
			str.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
			# Replaces any - with _ using tr.
			str.tr!("-", "_")
			# Makes the string lowercase.
			str.downcase
		end

		def sql_strings(value)
      case value
      when String
        "'#{value}'"
      when Numeric
        value.to_s
      else
        "null"
      end
    end

    def convert_keys(options)
      options.keys.each {|k| options[k.to_s] = options.delete(k) if k.kind_of?(Symbol)}
      options
    end

    def instance_variables_to_hash(obj)
      Hash[obj.instance_variables.map{ |var| ["#{var.to_s.delete('@')}", obj.instance_variable_get(var.to_s)]}]
    end

    def reload_obj(dirty_obj)
      persisted_obj = dirty_obj.class.find(dirty_obj.id)
      dirty_obj.instance_variables.each do |instance_variable|
        dirty_obj.instance_variable_set(instance_variable, persisted_obj.instance_variable_get(instance_variable))
      end
    end
    
	end
end