module XCRes
	class String
		attr_reader :key
		attr_reader :value
		attr_reader :comment

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