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
	end
end