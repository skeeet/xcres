require 'xcres/analyzer/resources_analyzer/sound_analyzer/sound_resources_analyzer'

module XCRes
  module ResourcesAnalyzer

    # A +LooseResourcesAnalyzer+ scans the project for resources, which are
    # loosely placed in the project or in a group and should be included in the
    # output file.
    #
    class LooseSoundResourcesAnalyzer < SoundResourcesAnalyzer

      def analyze
        @sections = [build_section_for_loose_sounds]
        super
      end

      # Build a section for loose sound resources in the project
      #
      # @return [Section]
      #
      def build_section_for_loose_sounds
        sound_files = find_sound_files(resources_files.map(&:path))

        log "Found #%s sound files in project.", sound_files.count

        data = build_sound_section_data(sound_files, use_basename: [:key, :path])

        new_section('Sounds', data)
      end

    end

  end
end
