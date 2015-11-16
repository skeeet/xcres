require 'xcres/analyzer/analyzer'
require 'nokogiri'

module XCRes

  # A +StringsAnalyzer+ scans the project for resources,
  # which should be included in the output file.
  #
  class XIBAnalyzer < Analyzer


    def analyze
      log 'Nib files in project: %s', xib_file_refs.map(&:path)

      @sections = [build_section]
    end

    # Build the section
    #
    # @return [Section]
    #
    def build_section
      selected_file_refs = xib_file_refs

      # Apply ignore list
      file_paths = filter_exclusions(selected_file_refs.map(&:path))
      filtered_file_refs = selected_file_refs.select { |file_ref| file_paths.include? file_ref.path }
      rel_file_paths = filtered_file_refs.map { |p| p.real_path.relative_path_from(Pathname.pwd) }

      log 'Non-ignored .xib files: %s', rel_file_paths.map(&:to_s)

      keys_by_file = {}
      for path in rel_file_paths
        keys_by_file[path] = keys_by_file(path)
      end
      items = keys_by_file.values.reduce({}, :merge)

      new_section('ReuseIdentifiers', items)
    end

    # Discover all references to .strings files in project (e.g. Localizable.strings)
    #
    # @return [Array<PBXFileReference>]
    #
    def xib_file_refs
      @xib_file_refs ||= find_file_refs_by_extname '.xib'
    end

    # Read a .xib file given as a path
    #
    # @param [Pathname] path
    #        the path of the strings file
    #
    # @return [Hash]
    #
    def read_xib_file(path)
      raise ArgumentError, "File '#{path}' doesn't exist" unless path.exist?
      raise ArgumentError, "File '#{path}' is not a file" unless path.file?
      error = `plutil -lint -s "#{path}" 2>&1`
      raise ArgumentError, "File %s is malformed:\n#{error}" % path.to_s unless $?.success?
      json_or_error = `plutil -convert json "#{path}" -o -`.chomp
      raise ArgumentError, "File %s couldn't be converted to JSON.\n#{json_or_error}" % path.to_s unless $?.success?
      JSON.parse(json_or_error.force_encoding('UTF-8'))
    rescue EncodingError => e
      raise StandardError, "Encoding error in #{path}: #{e}"
    end

    # Read a file and collect all its keys
    #
    # @param  [Pathname] path
    #         the path to the .strings file to read
    #
    # @return [Hash{String => Hash}]
    #
    def keys_by_file(path)
      begin
        # Load strings file contents
        xibs = read_xib_file(path)

        keys = Hash[xibs.map do |key, value|
          # TODO: Analyze xml and add for key
          found_identifiers = []
          [key, found_identifiers]
        end]

        log 'Found %s reuse identifiers in file %s', keys.count, path

        keys
      rescue ArgumentError => error
        raise ArgumentError, 'Error while reading %s: %s' % [path, error]
      end
    end

  end
end
