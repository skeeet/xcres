require 'xcres/analyzer/resources_analyzer/base_resources_analyzer'

module XCRes
  module ResourceTypes
    # A +ImageResource+ is a type common for all sounds.
    #
    class SoundResource < BaseResource

      def filter_words
        return ['sound', 'melody', 'music']
      end

      def filter_files file_paths
        filtered_files = super.filter_files file_paths
        filtered_files.select { |path| path.to_s.match /\.(caf|raw|wav|aiff?|mp3)$/ }
        return filtered_files
      end

      def resource_type
        return "Sound"
      end
    end
  end
end