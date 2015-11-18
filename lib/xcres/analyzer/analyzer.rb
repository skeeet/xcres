require 'xcodeproj'
require 'xcres/helper/file_helper'
require 'xcres/model/section'
require 'xcres/analyzer/resource_types/base_resource'

module XCRes

  # An +Analyzer+ scans the project for references,
  # which should be included in the output file.
  #
  class Analyzer
    include XCRes::FileHelper

    # @return [PBXNativeTarget]
    #         the application target of the #project to analyze.
    attr_reader :target

    # @return [Array<Section>]
    #         the built sections
    attr_reader :sections

    # @return [Hash]
    #         the options passed to the sections
    attr_accessor :options

    # @return [Array<String>]
    #         the exclude file patterns
    attr_accessor :exclude_file_patterns

    # @return [Logger]
    #         the logger
    attr_accessor :logger

    delegate :inform, :log, :success, :warn, :fail, to: :logger

    # Initialize a new analyzer
    #
    # @param [PBXNativeTarget] target
    #        see +target+.
    #
    # @param [Hash] options
    #        see subclasses.
    #
    def initialize(target=nil, options={})
      @target = target
      @sections = []
      @exclude_file_patterns = []
      @options = options
    end

    # Analyze the project
    #
    # @return [Array<Section>]
    #         the built sections
    #
    def analyze
      @sections = @sections.compact.reject { |s| s.items.nil? || s.items.empty? }
    end

    # Return the Xcode project to analyze
    #
    # @return [Xcodeproj::Project]
    #
    def project
      target.project
    end

    # Create a new +Section+.
    #
    # @param  [String] name
    #         see Section#name
    #
    # @param  [Hash] items
    #         see Section#items
    #
    # @param  [Hash] options
    #         see Section#options
    #
    # @return [XCRes::Section]
    #
    def new_section(name, data, options={})
      XCRes::Section.new(name, data, self.options.merge(options))
    end

    # Apply the configured exclude file patterns to a list of files
    #
    # @param [Array<Pathname>] file_paths
    #        the list of files to filter
    #
    # @param [Array<Pathname>]
    #        the filtered list of files
    #
    def filter_exclusions file_paths
      file_paths.reject do |path|
        exclude_file_patterns.any? { |pattern| File.fnmatch("#{pattern}", path) || File.fnmatch("**/#{pattern}", path) }
      end
    end

    # Discover all references to files with a specific extension in project,
    # which belong to a resources build phase of an application target.
    #
    # @param  [String] extname
    #         the extname, which contains a leading dot
    #         e.g.: '.bundle', '.strings'
    #
    # @return [Array<PBXFileReference>]
    #
    def find_file_refs_by_extname(extname)
      project.files.select do |file_ref|
        File.extname(file_ref.path) == extname \
        && is_file_ref_included_in_application_target?(file_ref)
      end
    end

    # Checks if a file ref is included in any resources build phase of any
    # of the application targets of the #project.
    #
    # @param  [PBXFileReference] file_ref
    #         the file to search for
    #
    # @return [Bool]
    #
    def is_file_ref_included_in_application_target?(file_ref)
      resources_files.include?(file_ref)
    end

    # Find files in resources build phases of application targets
    #
    # @return [Array<PBXFileReference>]
    #
    def resources_files
      target.resources_build_phase.files.map do |build_file|
        if build_file.file_ref.is_a?(Xcodeproj::Project::Object::PBXGroup)
          build_file.file_ref.recursive_children
        else
          [build_file.file_ref]
        end
      end.flatten.compact
    end

    # Derive a key from a resource path
    #
    # @param  [String] path
    #         the path to the resource
    #
    # @return [String]
    #
    def key_from_path path, resource_type = nil
        key = path.to_s

        # Get rid of the file extension
        key = key.sub /#{File.extname(path)}$/, ''

        # Graphical assets tend to contain words, which you want to strip.
        # Because we want to list the words to ignore only in one variant,
        # we have to ensure that the icon name is prepared for that, without
        # loosing word separation if camel case was used.
        key = key.underscore.downcase

        if !resource_type.nil? then
            for filter_word in resource_type.filter_words do
                key = key.gsub filter_word, ''
            end
        end

        # Remove unnecessary underscores
        key = key.gsub /^_*|_*$|(_)_+/, '\1'

        return key
    end
  end
end
