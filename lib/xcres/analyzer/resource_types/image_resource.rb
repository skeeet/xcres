require 'xcres/analyzer/resource_types/base_resource'

module XCRes::ResourceTypes

  # A +ImageResource+ is a type common for all images.
  #
  class ImageResource < BaseResource

    # Defined words that should be filtered out from the generated name
    #
    # @return [Array<String>]
    #         prohibited words
    #
    def filter_words
      return ['icon', 'image']
    end

    # Perform filtering of the file paths down to files relevant for this type only
    #
    # @param  [Array<String>] file_paths
    #         array of file paths to filter
    #
    # @return [Array<String>]
    #         filtered paths
    #
    def filter_files file_paths
      filtered_files = super(file_paths)
      return filter_device_specific_image_paths(filtered_files)
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
      return !path.to_s.match(/\.(png|jpe?g|gif)$/).nil?
    end

    # Defined human-readable name of this resource type
    #
    # @return [String]
    #         resource type name
    #
    def resource_type
      return 'Images'
    end

    # Filter out device scale and idiom specific images (retina, ipad),
    # but ensure the base exist once
    #
    # @param  [Array<Pathname>] file_paths
    #         the file paths to filter
    #
    # @return [Array<String>]
    #         the filtered file paths
    #
    def filter_device_specific_image_paths file_paths
      file_paths.map do |path|
        path.to_s.gsub /(@2x)?(~(iphone|ipad))?(?=\.\w+$)/, ''
      end.to_set.to_a
    end
  end
end