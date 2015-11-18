module XCRes::ResourceTypes

  # A +BaseResource+ is a common class for all resource types.
  #
  class BaseResource

    # Defined words that should be filtered out from the generated name
    #
    # @return [Array<String>]
    #         prohibited words
    #
    def filter_words
      return []
    end

    # Perform filtering of the file paths down to files relevant for this type only
    #
    # @param  [Array<String>] file_paths
    #         array of file paths to filter
    #
    # @return [Array<String>]
    #         filtered paths
    #
    def filter_files file_paths
      filtered_files = file_paths
      filtered_files.select! { |path| match_file(path) }
      return filtered_files
    end

    # Detect if a given file is of the type that matches this resource type
    #
    # @param  [String] path
    #         path to the file
    #
    # @return [Bool]
    #         if file matches the type
    #
    def match_file path
      return false
    end

    # Defined human-readable name of this resource type
    #
    # @return [String]
    #         resource type name
    #
    def resource_type
      return 'Undefined'
    end
  end
end
