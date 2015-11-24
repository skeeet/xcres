require 'xcres/analyzer/analyzer'
require 'ttfunk'

module XCRes

  # A +FontAnalyzer+ scans the project for included fonts.
  #
  class FontAnalyzer < Analyzer

    def analyze
      log 'Font files in project: %s', font_file_refs.map(&:path)

      @sections = [build_section]
    end

    # Build the section
    #
    # @return [Section]
    #
    def build_section
      selected_file_refs = font_file_refs

      # Apply ignore list
      file_paths = filter_exclusions(selected_file_refs.map(&:path))
      filtered_file_refs = selected_file_refs.select { |file_ref| file_paths.include? file_ref.path }
      rel_file_paths = filtered_file_refs.map { |p| p.real_path.relative_path_from(Pathname.pwd) }

      log 'Non-ignored font files: %s', rel_file_paths.map(&:to_s)

      fonts = {}

      for path in rel_file_paths
        filename = path.relative_path_from(path.parent)
        extension = File.extname(path)
        key = filename.to_s.sub /#{extension}$/, ''
        fonts[key] = postscript_name_from_file(path)
      end

      new_section('Fonts', fonts)
    end

    # Discover all references to font files in project
    #
    # @return [Array<PBXFileReference>]
    #
    def font_file_refs
      @font_file_refs ||= (find_file_refs_by_extname('.otf') + find_file_refs_by_extname('.ttf'))
    end

    # Extracts PostScript name from a font file
    #
    # @param [Pathname] path
    #        the path of the font file
    #
    # @return [String]
    #
    def postscript_name_from_file path
      file = TTFunk::File.open(path.to_s)
      return file.name.postscript_name
    end
  end
end
