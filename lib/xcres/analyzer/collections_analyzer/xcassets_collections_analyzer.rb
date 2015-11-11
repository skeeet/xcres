require 'xcres/analyzer/collections_analyzer/base_collections_analyzer'
require 'xcres/model/xcassets/bundle'
require 'set'

module XCRes
  module CollectionsAnalyzer

    # A +XCAssetsCollectionsAnalyzer+ scans the project for asset bundles,
    # that should be included in the project
    #
    class XCAssetsCollectionsAnalyzer < BaseCollectionsAnalyzer

      def analyze
        @sections = build_sections_for_xcassets
        super
      end

      # Build a section for each asset catalog if it contains any resources
      #
      # @return [Array<Section>]
      #         the built sections
      #
      def build_sections_for_xcassets
        file_refs = find_file_refs_by_extname '.xcassets'

        log "Found #%s asset catalogs in project.", file_refs.count

        file_refs.map do |file_ref|
          bundle = XCAssets::Bundle.open(file_ref.real_path)
          section = build_section_for_xcassets(bundle)
          log 'Add section for %s with %s elements.', section.name, section.items.count unless section.nil?
          section
        end.compact
      end

      # Build a section for a asset catalog
      #
      # @param  [XCAssets::Bundle] xcassets_bundle
      #         the file reference to the resources bundle file
      #
      # @return [Section]
      #         a section or nil
      #
      def build_section_for_xcassets bundle

        log "Found asset catalog %s with #%s resources.", bundle.path.basename, bundle.resources.count
        section_name = "#{basename_without_ext(bundle.path)}Assets"
        section_hash = Hash.new

        linked_resources.each do |resource_type|

	        relevant_files = resource_type.filter_files(bundle.resources.map(&:path))
          relevant_files = filter_exclusions(relevant_files)

	        log "Found #%s %s in the asset catalog.", relevant_files.count, resource_type.resource_type.downcase

	        subsection_name = resource_type.resource_type
	        subsection_data = build_section_data(relevant_files, resource_type, {
	          use_basename:     [:path],
	          path_without_ext: true
	        })
          section_hash[subsection_name] = new_section(subsection_name, subsection_data)
	    end

	    new_section(section_name, section_hash)
      end
    end
  end
end