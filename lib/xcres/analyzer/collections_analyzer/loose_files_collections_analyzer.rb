require 'xcres/analyzer/collections_analyzer/base_collections_analyzer'

module XCRes
  module CollectionsAnalyzer

    # A +LooseFilesCollectionsAnalyzer+ scans the project for separate files,
    # that should be included in the project
    #
    class LooseFilesCollectionsAnalyzer < BaseCollectionsAnalyzer
      def analyze
        @sections = [build_section_for_loose_files]
        super
      end

      def exclude_file_patterns
        super + ['Default.*', 'Default@2x.*', 'Default-568h@2x.*']
      end

      # Build a section for loose resource files in the project
      #
      # @return [Section]
      #
      def build_section_for_loose_files
        relevant_files = linked_resource.filter_files(resources_files.map(&:path))
        filter_exclusions(relevant_files)

        log "Found #%s %s files in project.", relevant_files.count, linked_resource.resource_type.downcase

        section_name = linked_resource.resource_type
        section_data = build_section_data(relevant_files, use_basename: [:key, :path])
        new_section(section_name, section_data)
      end
    end
  end
end