require 'xcres/analyzer/resource_types/base_resource'

module XCRes
  module ResourceTypes
    # A +ImageResource+ is a type common for all sounds.
    #
    class SoundResource < BaseResource

      def filter_words
        return ['sound', 'melody', 'music']
      end

      def match_file path
        return path.to_s.match /\.(caf|raw|wav|aiff?|mp3)$/
      end

      def resource_type
        return 'Sounds'
      end
    end
  end
end