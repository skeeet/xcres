require 'xcres/analyzer/analyzer'
require 'nokogiri'

module XCRes

  # A +IBAnalyzer+ scans the project for identifiers inside xib and storyboard files,
  # which should be included in the output file.
  #
  class IBAnalyzer < Analyzer


    def analyze
      log 'IB files in project: %s', ib_file_refs.map(&:path)

      @sections = build_sections
    end

    # Build the section
    #
    # @return [Section]
    #
    def build_sections
      selected_file_refs = ib_file_refs

      # Apply ignore list
      file_paths = filter_exclusions(selected_file_refs.map(&:path))
      filtered_file_refs = selected_file_refs.select { |file_ref| file_paths.include? file_ref.path }
      rel_file_paths = filtered_file_refs.map { |p| p.real_path.relative_path_from(Pathname.pwd) }

      log 'Non-ignored IB files: %s', rel_file_paths.map(&:to_s)

      cell_ids = {}
      segue_ids = {}
      storyboard_ids = {}
      restoration_ids = {}
      for path in rel_file_paths
        filename = path.relative_path_from(path.parent)
        extension = File.extname(path)
        key = filename.to_s.sub /#{extension}$/, ''

        begin

          # Load IB file contents
          ib_file = read_ib_file(path)
          doc = Nokogiri::XML(ib_file)

          # Find cell reuse identifiers
          c_ids = find_elements(doc, '*', 'reuseIdentifier')
          log 'Found %s reuse identifiers in file %s', c_ids.count, path
          cell_ids[key] = XCRes::Section.new(key, c_ids) if c_ids.count > 0

          if extension == '.storyboard' then

            # Find segue identifiers
            s_ids = find_elements(doc, 'segue', 'identifier')
            log 'Found %s segue identifiers in file %s', s_ids.count, path
            segue_ids[key] = XCRes::Section.new(key, s_ids) if s_ids.count > 0

            # Find storyboard identifiers
            b_ids = find_elements(doc, '*', 'storyboardIdentifier')
            log 'Found %s storyboard identifiers in file %s', b_ids.count, path
            storyboard_ids[key] = XCRes::Section.new(key, b_ids) if b_ids.count > 0

            # Find restoration identifiers
            r_ids = find_elements(doc, '*', 'restorationIdentifier')
            log 'Found %s restoration identifiers in file %s', r_ids.count, path
            restoration_ids[key] = XCRes::Section.new(key, r_ids) if r_ids.count > 0
          end

        rescue ArgumentError => error
          raise ArgumentError, 'Error while reading %s: %s' % [path, error]
        end
      end

      res = []
      res += [new_section('ReuseIdentifiers', cell_ids)] if cell_ids.count > 0
      res += [new_section('SegueIdentifiers', segue_ids)] if segue_ids.count > 0
      res += [new_section('StoryboardIdentifiers', storyboard_ids)] if storyboard_ids.count > 0
      res += [new_section('RestorationIdentifiers', restoration_ids)] if restoration_ids.count > 0
      res
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

    # Searches for a specific tag with specific attribute
    # name inside the given XML contents
    #
    # @param  [String] xml
    #         XML contents of the IB file
    #
    # @param  [String] tag_name
    #         Name of the XML tag
    #
    # @param  [String] attr_name
    #         Name of the tag's attribute
    #
    # @return [Hash{String => Hash}]
    #
    def find_elements(xml, tag_name, attr_name)
      keys = {}
      xml.xpath("//#{tag_name}[@#{attr_name}]").each do |n|
        identifier = n.attribute(attr_name).to_s
        id_key = key_from_path(identifier)
        keys[id_key] = identifier
      end
      keys
    end
  end
end
