module XCRes
  module ResourceTypes

    # A +BaseResource+ is a common class for all resource types.
    #
    class BaseResource

      def self.filter_words
        return []
      end

      def self.filter_files file_paths
        return file_paths
      end

      def self.resource_type
        return 'Undefined'
      end
    end
  end
end
