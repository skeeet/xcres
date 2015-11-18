require 'xcres/analyzer/resource_types/base_resource'

module XCRes::ResourceTypes

  # A +ImageResource+ is a type common for all sounds.
  #
  class StoryboardResource < BaseResource

    # Defined words that should be filtered out from the generated name
    #
    # @return [Array<String>]
    #         prohibited words
    #
    def filter_words
      return ['view_controller', 'scene']
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
      return !path.to_s.match(/\.(storyboard)$/).nil?
    end

    # Defined human-readable name of this resource type
    #
    # @return [String]
    #         resource type name
    #
    def resource_type
      return 'Storyboards'
    end
  end
end