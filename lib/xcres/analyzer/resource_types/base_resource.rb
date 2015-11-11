module XCRes
  module ResourceTypes

    # A +BaseResource+ is a common class for all resource types.
    #
    class BaseResource

      def filter_words
        return []
      end

      def filter_files file_paths
        filtered_files = file_paths
        filtered_files.select! { |path| match_file(path) }
        return filtered_files
      end

      def match_file path
        return false
      end

      def resource_type
        return 'Undefined'
      end
    end
  end
end
