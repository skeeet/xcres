module XCRes
	class String
	    # @return [String]
	    #         the key for localizable string
		attr_reader :key
	    # @return [String]
	    #         the value for localizable string (should be equal to the key inside .strings file)
		attr_reader :value
	    # @return [String]
	    #         comment that is appended in the .h file
		attr_reader :comment

	    # Initialize a new string
	    #
	    # @param  [String] key
	    #         see #key
	    #
	    # @param  [String] value
	    #         see #value
	    #
	    # @param  [String] comment
	    #         see #comment
	    #
	    #
		def initialize key, value, comment
			@key = key
			@value = value
			@comment = comment
		end

	    def ==(other)
	      self.key == other.key \
	        && self.value == other.value \
	        && self.comment == other.comment
	    end

	    alias eql? ==
	end
end