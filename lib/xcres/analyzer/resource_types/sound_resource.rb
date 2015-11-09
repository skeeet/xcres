require 'xcres/analyzer/resource_types/base_resource'

module XCRes
  module ResourceTypes
    # A +ImageResource+ is a type common for all sounds.
    #
    class SoundResource < BaseResource

      def self.filter_words
        return ['sound', 'melody', 'music']
      end

      def self.filter_files file_paths
        filtered_files = super(file_paths)
        filtered_files.select { |path| path.to_s.match /\.(caf|raw|wav|aiff?|mp3)$/ }
        return filtered_files
      end

      def self.resource_type
        return 'Sounds'
      end
    end
  end
end