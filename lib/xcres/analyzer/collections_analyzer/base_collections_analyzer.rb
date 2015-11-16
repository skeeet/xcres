require 'xcres/analyzer/analyzer'
require 'xcres/analyzer/resource_types/base_resource'

module XCRes
  module CollectionsAnalyzer

    # A +BaseCollectionsAnalyzer+ scans the project for collections of resources,
    # such as bundles, asset bundles or loose files.
    #
    class BaseCollectionsAnalyzer < Analyzer

      # @return [Array<BaseResource>]
      #         resources that should be recognized inside this container
      attr_accessor :linked_resources

      def initialize(target=nil, options={})
        @linked_resources = options[:linked_resources]
        super(target, options)
      end

      # Get a list of all files in a directory
      #
      # @param  [Pathname] dir
      #         the directory
      #
      # @return [Array<Pathname>]
      #         the file paths relative to the given dir
      #
      def find_files_in_dir dir
        unless dir.exist?
          warn "Can't find files in dir %s as it doesn't exist!",
            dir.relative_path_from(project.path + '..').to_s
          return []
        end
        Dir.chdir dir do
          Dir['**/*'].map { |path| Pathname(path) }
        end
      end

      # Build a keys to paths mapping
      #
      # @param  [Array<Pathname>] file_paths
      #         the file paths, which will be the values of the mapping
      #
      # @param  [Hash] options
      #         valid options are:
      #         * [Array<Symbol>] :use_basename
      #           can contain :key and :path
      #
      # @return [Hash{String => Pathname}]
      #
      def build_section_data file_paths, resource_type, options={}
        options = {
          use_basename: [],
          path_without_ext: false,
        }.merge options

        # Transform image file paths to keys
        keys_to_paths = {}
        for path in file_paths
          basename = File.basename(path)
          key = key_from_path(options[:use_basename].include?(:key) ? basename : path.to_s, resource_type)
          transformed_path = options[:use_basename].include?(:path) ? basename : path
          if options[:path_without_ext]
            transformed_path = transformed_path.to_s.sub /#{File.extname(path)}$/, ''
          end
          keys_to_paths[key] = transformed_path.to_s
        end

        keys_to_paths
      end
    end

  end
end
