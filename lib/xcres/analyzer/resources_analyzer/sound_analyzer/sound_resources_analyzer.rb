require 'xcres/analyzer/resources_analyzer/base_resources_analyzer'

module XCRes
  module ResourcesAnalyzer
    # A +SoundResourcesAnalyzer+ scans the project for images, that
    # should be included in the output file.
    #
    class SoundResourcesAnalyzer < BaseResourcesAnalyzer

      # Find sound files in a given list of file paths
      #
      # @param  [Array<Pathname>] file_paths
      #         the list of files
      #
      # @return [Array<Pathname>]
      #         the filtered list
      #
      def find_sound_files file_paths
        file_paths.select { |path| path.to_s.match /\.(caf|raw|wav)$/ }
      end


      # Build a section for sound resources
      #
      # @param  [Array<String>] sound_files
      #
      # @param  [Hash] options
      #         see #build_section_data
      #
      # @return [Hash{String => Pathname}]
      #
      def build_sound_section_data sound_file_paths, options={}
        sound_file_paths = filter_exclusions(sound_file_paths)
        build_section_data(sound_file_paths, options)
      end

    end
  end
end