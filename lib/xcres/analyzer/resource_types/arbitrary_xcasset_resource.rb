require 'xcres/analyzer/resource_types/base_resource'

module XCRes
  module ResourceTypes
    # A +ArbitraryXCAssetResource+ is a type for datasets inside asset catalogs.
    #
    class ArbitraryXCAssetResource < BaseResource

      def filter_words
        return []
      end

      def match_file path
        return !path.to_s.match(/\.dataset$/).nil?
      end

      def resource_type
        return 'Data'
      end
    end
  end
end