require File.expand_path('../../../spec_helper', __FILE__)

describe 'XCRes::CollectionsAnalyzer::XCAssetsCollectionsAnalyzer' do

  def subject
    XCRes::CollectionsAnalyzer::XCAssetsCollectionsAnalyzer
  end

  before do
    @analyzer = subject.new
    @analyzer.logger = stub('Logger', :log)
  end

  describe '#build_sections_for_xcassets' do
    it 'should return an empty array if the project does not contain any asset catalogs' do
      @analyzer.expects(:find_file_refs_by_extname).returns([])
      @analyzer.build_sections_for_xcassets.should.eql?([])
    end

  #   it 'should build sections for given asset catalog' do
  #     mock_bundle_a = mock('Bundle') { stubs(path: 'A.xcassets', real_path: 'b/A.xcassets'), contents: [
  #         'AppIcon.appiconset',
  #       ]) }
  #     mock_bundle_b = mock('Bundle') { stubs(path: 'B.xcassets', real_path: 'b/B.xcassets') }
  #     section = XCRes::Section.new('A', { 
  #       'Images' => XCRes::Section.new('Images', { 'app' => 'AppIcon.appiconset' })
  #       } { 'a' => 'a.gif' })
  #     @analyzer.expects(:find_file_refs_by_extname).returns([mock_bundle_a, mock_bundle_b])
  #     @analyzer.expects(:build_section_for_xcassets).with(mock_bundle_a).returns(section)
  #     @analyzer.expects(:build_section_for_xcassets).with(mock_bundle_b).returns(nil)
  #     @analyzer.build_section_for_xcassets.should.be.eql?([section])
  #   end
  end

  # describe '#build_section_for_xcassets' do
  #   before do
  #     @mock_bundle = mock('Bundle') { stubs(path: [ basename => 'A.xcassets' ], real_path: 'b/A.xcassets', contents: [
  #         'AppIcon.appiconset',
  #         'LaunchImage.launchimageset',
  #         'my_stuff.imageset',
  #         'my_data.dataset',
  #       ]) }
  #   end

  #   describe 'Images' do

  #     before do
  #       @analyzer = subject.new(nil, linked_resources: [ XCRes::ResourceTypes::ImageXCAssetResource.new ])
  #       @analyzer.logger = stub('Logger', :log)
  #     end

  #     it 'should return nil if the asset catalog does not contain any images' do
  #       @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.m')])
  #       @analyzer.build_section_for_xcassets(@mock_bundle).items['Images'].items.should.be.empty
  #     end

  #     it 'should return nil if the asset catalog does not contain any valid images' do
  #       @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.imageset')])
  #       @analyzer.exclude_file_patterns = ['a.gif']
  #       @analyzer.build_section_for_xcassets(@mock_bundle).items['Images'].items.should.be.empty
  #     end

  #     it 'should build a new section if the asset catalog contains valid images' do
  #       @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.imageset')])
  #       @analyzer.build_section_for_xcassets(@mock_bundle).items['Images'].should.be.eql?(XCRes::Section.new('A', 'a' => 'a.imageset'))
  #     end

  #     it 'should return nil for other kinds of sections' do
  #       @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.imageset')])
  #       @analyzer.build_section_for_xcassets(@mock_bundle).items['Data'].items.should.be.empty
  #     end
  #   end

  #   describe 'Data' do

  #     before do
  #       @analyzer = subject.new(nil, linked_resources: [ XCRes::ResourceTypes::ArbitraryXCAssetResource.new ])
  #       @analyzer.logger = stub('Logger', :log)
  #     end

  #     it 'should return nil if the asset catalog does not contain any data' do
  #       @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.m')])
  #       @analyzer.build_section_for_xcassets(@mock_bundle).items['Data'].items.should.be.empty?
  #     end

  #     it 'should return nil if the asset catalog does not contain any valid data' do
  #       @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.dataset')])
  #       @analyzer.exclude_file_patterns = ['a.dataset']
  #       @analyzer.build_section_for_xcassets(@mock_bundle).items['Data'].items.should.be.empty?
  #     end

  #     it 'should build a new section if the asset catalog contains valid valid' do
  #       @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.dataset')])
  #       @analyzer.build_section_for_xcassets(@mock_bundle).items['Data'].should.be.eql?(XCRes::Section.new('A', 'a' => 'a.dataset'))
  #     end

  #     it 'should return nil for other kinds of sections' do
  #       @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.dataset')])
  #       @analyzer.build_section_for_xcassets(@mock_bundle).items['Images'].items.should.be.empty
  #     end
  #   end

  # end

end
