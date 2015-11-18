require 'xcres/analyzer/collections_analyzer/base_collections_analyzer'

module XCRes
  module CollectionsAnalyzer

    # A +BundleCollectionsAnalyzer+ scans the project for bundles of resources,
    # that should be included in the project
    #
    class BundleCollectionsAnalyzer < BaseCollectionsAnalyzer

      def analyze
        @sections = build_sections_for_bundles
        super
      end

      # Build a section for each bundle if it contains any resources
      #
      # @return [Array<Section>]
      #         the built sections
      #
      def build_sections_for_bundles
        bundle_file_refs = find_file_refs_by_extname '.bundle'

        log "Found #%s resource bundles in project.", bundle_file_refs.count

        bundle_file_refs.map do |file_ref|
          section = build_section_for_bundle(file_ref)
          log 'Add section for %s with %s elements.', section.name, section.items.count unless section.nil?
          section
        end.compact
      end

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

        log "Found bundle %s with #%s files.", bundle_file_ref.path, bundle_files.count

        section_hash = Hash.new

        linked_resources.each do |resource_type|
	        relevant_files = resource_type.filter_files(bundle_files)
          relevant_files = filter_exclusions(relevant_files)

	        log "Found #%s %s in the bundle.", relevant_files.count, resource_type.resource_type.downcase

	        subsection_name = resource_type.resource_type
	        subsection_data = build_section_data(relevant_files, resource_type)
          section_hash[subsection_name] = new_section(subsection_name, subsection_data)
	      end

        return nil if section_hash.empty?

        section_name = basename_without_ext(bundle_file_ref.path)
  	    new_section(section_name, section_hash)
      end
    end
  end
end