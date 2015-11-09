require 'xcres/analyzer/analyzer'

module XCRes
  module ResourceTypes

    # A +BaseResource+ is a common class for all resource types.
    #
    class BaseResource

      def filter_words
        return []
      end

      def filter_files file_paths
        return file_paths
      end

      def resource_type
        return "Undefined"
      end
    end
  end
end
