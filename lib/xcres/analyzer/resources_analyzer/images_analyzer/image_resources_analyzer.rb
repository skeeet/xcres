require 'xcres/analyzer/resources_analyzer/base_resources_analyzer'

module XCRes
  module ResourcesAnalyzer
    # A +ImageResourcesAnalyzer+ scans the project for images, that
    # should be included in the output file.
    #
    class ImageResourcesAnalyzer < BaseResourcesAnalyzer

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


      # Find image files in a given list of file paths
      #
      # @param  [Array<Pathname>] file_paths
      #         the list of files
      #
      # @return [Array<Pathname>]
      #         the filtered list
      #
      def find_image_files file_paths
        file_paths.select { |path| path.to_s.match /\.(png|jpe?g|gif)$/ }
      end



      # Build a section for image resources
      #
      # @param  [Array<String>] image_files
      #
      # @param  [Hash] options
      #         see #build_section_data
      #
      # @return [Hash{String => Pathname}]
      #
      def build_images_section_data image_file_paths, options={}
        image_file_paths = filter_exclusions(image_file_paths)
        image_file_paths = filter_device_specific_image_paths(image_file_paths)
        build_section_data(image_file_paths, options)
      end
    end
  end
end