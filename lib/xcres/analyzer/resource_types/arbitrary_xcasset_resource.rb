require 'xcres/analyzer/resource_types/base_resource'

module XCRes::ResourceTypes

  # A +ArbitraryXCAssetResource+ is a type for datasets inside asset catalogs.
  #
  class ArbitraryXCAssetResource < BaseResource

    # Detect if a given file is of the type that matches this resource type
    #
    # @param  [String] path
    #         path to the file
    #
    # @return [Bool]
    #         if file matches the type
    #
    def match_file path
      return !path.to_s.match(/\.dataset$/).nil?
    end

    # Defined human-readable name of this resource type
    #
    # @return [String]
    #         resource type name
    #
    def resource_type
      return 'Data'
    end
  end
end