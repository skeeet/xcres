require 'xcres/analyzer/resource_types/image_resource'

module XCRes::ResourceTypes

	# A +ImageResource+ is a type common for all images.
	#
	class ImageXCAssetResource < ImageResource

	  # Detect if a given file is of the type that matches this resource type
	  #
	  # @param  [String] path
	  #         path to the file
	  #
	  # @return [Bool]
	  #         if file matches the type
	  #
	  def match_file path
	    return !path.to_s.match( /\.(appiconset|imageset|launchimage)$/).nil?
	  end
	end
end