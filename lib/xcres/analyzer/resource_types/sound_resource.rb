require 'xcres/analyzer/resource_types/base_resource'

module XCRes
  module ResourceTypes
    # A +ImageResource+ is a type common for all sounds.
    #
    class SoundResource < BaseResource

      def filter_words
        return ['sound', 'melody', 'music']
      end

      def filter_files file_paths, options = {}
        filtered_files = super(file_paths, options)
        unless options[:ignore_extensions] then
          filtered_files.select! { |path| path.to_s.match /\.(caf|raw|wav|aiff?|mp3)$/ }
        end
        return filtered_files
      end

      def resource_type
        return 'Sounds'
      end
    end
  end
end