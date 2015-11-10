require 'xcres/analyzer/resource_types/image_resource'

module XCRes
  module ResourceTypes
    # A +ImageResource+ is a type common for all images.
    #
    class ImageXCAssetResource < ImageResource

      def match_file path
        return path.to_s.match /\.(appiconset|imageset|launchimage)$/
      end
    end
  end
end