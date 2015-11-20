require 'xcres/analyzer/analyzer'
require 'nokogiri'

module XCRes

  # A +IBAnalyzer+ scans the project for identifiers inside xib and storyboard files,
  # which should be included in the output file.
  #
  class IBAnalyzer < Analyzer


    def analyze
      log 'IB files in project: %s', ib_file_refs.map(&:path)

      @sections = [build_section]
    end

    # Build the section
    #
    # @return [Section]
    #
    def build_section
      selected_file_refs = ib_file_refs

      # Apply ignore list
      file_paths = filter_exclusions(selected_file_refs.map(&:path))
      filtered_file_refs = selected_file_refs.select { |file_ref| file_paths.include? file_ref.path }
      rel_file_paths = filtered_file_refs.map { |p| p.real_path.relative_path_from(Pathname.pwd) }

      log 'Non-ignored IB files: %s', rel_file_paths.map(&:to_s)

      items = {}
      for path in rel_file_paths
        filename = path.relative_path_from(path.parent)
        key = filename.to_s.sub /#{File.extname(path)}$/, ''
        items[key] = XCRes::Section.new(key, keys_by_file(path))
      end

      new_section('ReuseIdentifiers', items)
    end

    # Discover all references to IB files in project
    #
    # @return [Array<PBXFileReference>]
    #
    def ib_file_refs
      @ib_file_refs ||= (find_file_refs_by_extname('.xib') + find_file_refs_by_extname('.storyboard'))
    end

    # Read an IB file given as a path
    #
    # @param [Pathname] path
    #        the path of the IB file
    #
    # @return [Hash]
    #
    def read_ib_file(path)
      begin
        raise ArgumentError, "File '#{path}' doesn't exist" unless path.exist?
        raise ArgumentError, "File '#{path}' is not a file" unless path.file?
        return path.read
      rescue EncodingError => e
        raise StandardError, "Encoding error in #{path}: #{e}"
        return nil
      end
    end

    # Read a file and collect all its keys
    #
    # @param  [Pathname] path
    #         the path to the IB file to read
    #
    # @return [Hash{String => Hash}]
    #
    def keys_by_file(path)
      begin

        # Load strings file contents
        ib_file = read_ib_file(path)
        doc = Nokogiri::XML(ib_file)
        attr_name = 'reuseIdentifier'

        keys = {}

        doc.xpath("//*[@#{attr_name}]").each do |n|
          identifier = n.attribute(attr_name).to_s
          id_key = key_from_path(identifier)
          keys[id_key] = identifier
        end

        log 'Found %s reuse identifiers in file %s', keys.count, path

        keys
      rescue ArgumentError => error
        raise ArgumentError, 'Error while reading %s: %s' % [path, error]
      end
    end

  end
end
