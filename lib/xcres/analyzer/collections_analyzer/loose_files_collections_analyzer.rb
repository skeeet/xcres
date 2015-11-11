require 'xcres/analyzer/collections_analyzer/base_collections_analyzer'

module XCRes
  module CollectionsAnalyzer

    # A +LooseFilesCollectionsAnalyzer+ scans the project for separate files,
    # that should be included in the project
    #
    class LooseFilesCollectionsAnalyzer < BaseCollectionsAnalyzer

      def analyze
        @sections = build_section_for_loose_files
        super
      end

      def exclude_file_patterns
        super + ['Default.*', 'Default@2x.*', 'Default-568h.*', 'Default-568h@2x.*']
      end

      # Build a section for loose resource files in the project
      #
      # @return [Section]
      #
      def build_section_for_loose_files

        linked_resources.map do |resource_type|
          relevant_files = resource_type.filter_files(resources_files.map(&:path))
          relevant_files = filter_exclusions(relevant_files)

          log "Found #%s %s in the project.", relevant_files.count, resource_type.resource_type.downcase

          section_name = resource_type.resource_type
          section_data = build_section_data(relevant_files, resource_type, use_basename: [:key, :path])
          new_section(section_name, section_data)
        end.compact
      end
    end
  end
end