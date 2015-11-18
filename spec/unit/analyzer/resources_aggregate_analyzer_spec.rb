require File.expand_path('../../spec_helper', __FILE__)

describe 'XCRes::ResourcesAggregateAnalyzer' do

  def subject
    XCRes::ResourcesAggregateAnalyzer
  end

  before do
    @analyzer = subject.new
    @analyzer.logger = stub('Logger', :log)
  end

  describe '#analyze' do
    it 'should return all sections' do
      bundle_section_a = stub('Bundle Section A')
      bundle_section_b = stub('Bundle Section B')
      xcassets_image_section = stub('XCAssets Images Section')
      xcassets_data_section = stub('XCAssets Data Section')
      loose_image_section = stub('Loose Images Section')
      loose_sound_section = stub('Loose Sounds Section')
      loose_nibs_section = stub('Loose Nibs Section')

      XCRes::CollectionsAnalyzer::BundleCollectionsAnalyzer.any_instance
        .expects(:analyze).returns([bundle_section_a, bundle_section_b])
      XCRes::CollectionsAnalyzer::XCAssetsCollectionsAnalyzer.any_instance
        .expects(:analyze).returns([xcassets_image_section, xcassets_data_section])
      XCRes::CollectionsAnalyzer::LooseFilesCollectionsAnalyzer.any_instance
        .stubs(:analyze).returns([loose_image_section, loose_sound_section, loose_nibs_section])

      @analyzer.analyze.should.eql?([
        bundle_section_a, 
        bundle_section_b, 
        xcassets_image_section, 
        xcassets_data_section, 
        loose_image_section, 
        loose_sound_section,
        loose_nibs_section,
        loose_image_section, 
        loose_sound_section,
        loose_nibs_section,
      ])
    end

    it 'should return only bundle sections if there are no loose images' do
      bundle_section = stub('Bundle Section')
      xcassets_section = stub('XCAssets Section')

      XCRes::CollectionsAnalyzer::BundleCollectionsAnalyzer.any_instance
        .expects(:analyze).returns(bundle_section)
      XCRes::CollectionsAnalyzer::XCAssetsCollectionsAnalyzer.any_instance
        .expects(:analyze).returns(xcassets_section)
      XCRes::CollectionsAnalyzer::LooseFilesCollectionsAnalyzer.any_instance
        .stubs(:analyze).returns([])

      @analyzer.analyze.should.eql?([bundle_section, xcassets_section])
    end
  end

end
