require 'xcres/analyzer/aggregate_analyzer'
require 'xcres/analyzer/resources_analyzer/images_analyzer/bundle_image_resources_analyzer'
require 'xcres/analyzer/resources_analyzer/images_analyzer/loose_image_resources_analyzer'
require 'xcres/analyzer/resources_analyzer/images_analyzer/xcassets_analyzer'
require 'xcres/analyzer/resources_analyzer/sound_analyzer/loose_sound_resources_analyzer'

module XCRes

  # A +ResourcesAggregateAnalyzer+ scans the project for resources,
  # which should be included in the output file.
  #
  # It is a +AggregateAnalyzer+, which uses the following child analyzers:
  #  * +XCRes::ResourcesAnalyzer::BundleImageResourcesAnalyzer+
  #  * +XCRes::ResourcesAnalyzer::LooseImageResourcesAnalyzer+
  #  * +XCRes::ResourcesAnalyzer::XCAssetsAnalyzer+
  #  * +XCRes::ResourcesAnalyzer::LooseSoundResourcesAnalyzer+
  #
  class ResourcesAggregateAnalyzer < AggregateAnalyzer

    def analyze
      self.analyzers = []
      add_with_class ResourcesAnalyzer::BundleImageResourcesAnalyzer
      add_with_class ResourcesAnalyzer::LooseImageResourcesAnalyzer
      add_with_class ResourcesAnalyzer::XCAssetsAnalyzer
      add_with_class ResourcesAnalyzer::LooseSoundResourcesAnalyzer
      super
    end

  end

end
