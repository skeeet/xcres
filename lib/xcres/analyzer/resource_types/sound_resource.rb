require 'xcres/analyzer/resource_types/base_resource'

module XCRes::ResourceTypes

  # A +ImageResource+ is a type common for all sounds.
  #
  class SoundResource < BaseResource

    # Defined words that should be filtered out from the generated name
    #
    # @return [Array<String>]
    #         prohibited words
    #
    def filter_words
      return ['sound', 'melody', 'music']
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
      return !path.to_s.match(/\.(caf|raw|wav|aiff?|mp3)$/).nil?
    end

    # Defined human-readable name of this resource type
    #
    # @return [String]
    #         resource type name
    #
    def resource_type
      return 'Sounds'
    end
  end
end