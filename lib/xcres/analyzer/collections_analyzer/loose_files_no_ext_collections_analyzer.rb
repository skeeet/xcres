require 'xcres/analyzer/collections_analyzer/loose_files_collections_analyzer'

module XCRes
  module CollectionsAnalyzer

    # A +LooseFilesCollectionsAnalyzer+ scans the project for separate files,
    # that should be included in the project
    #
    class LooseFilesNoExtCollectionsAnalyzer < LooseFilesCollectionsAnalyzer

      def initialize(target=nil, options={})
        super(target, options)
        @use_filename_extension = false
      end
    end
  end
end