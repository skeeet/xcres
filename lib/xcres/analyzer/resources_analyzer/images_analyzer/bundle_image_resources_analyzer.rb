require 'xcres/analyzer/resources_analyzer/bundle_resources_analyzer'
require_relative 'image_helper'

module XCRes
  module ResourcesAnalyzer

    # A +BundleImageResourcesAnalyzer+ scans the project for bundles, whose image resources
    # should be included in the output file.
    #
    class BundleImageResourcesAnalyzer < BundleResourcesAnalyzer

      # Build a section for a resources bundle
      #
      # @param  [PBXFileReference] bundle_file_ref
      #         the file reference to the resources bundle file
      #
      # @return [Section]
      #         a section or nil
      #
      def build_section_for_bundle bundle_file_ref
        bundle_files = find_files_in_dir(bundle_file_ref.real_path)
        image_files = ImageHelper.find_image_files(bundle_files)

        log "Found bundle %s with #%s image files of #%s total files.", bundle_file_ref.path, image_files.count, bundle_files.count

        section_name = basename_without_ext(bundle_file_ref.path)
        section_data = build_images_section_data(image_files)
        new_section(section_name, section_data)
      end
    end
  end
end
