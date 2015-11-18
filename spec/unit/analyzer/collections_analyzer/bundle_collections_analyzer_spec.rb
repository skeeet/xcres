require File.expand_path('../../../spec_helper', __FILE__)

describe 'XCRes::CollectionsAnalyzer::BundleCollectionsAnalyzer' do

  def subject
    XCRes::CollectionsAnalyzer::BundleCollectionsAnalyzer
  end

  before do
    @analyzer = subject.new
    @analyzer.logger = stub('Logger', :log)
  end

  describe '#build_sections_for_bundles' do
    it 'should return an empty array if the project does not contain any resource bundles' do
      @analyzer.expects(:find_file_refs_by_extname).returns([])
      @analyzer.build_sections_for_bundles.should.eql?([])
    end

    it 'should build sections for given bundles' do
      mock_bundle_a = mock('BundleFileRef').stubs(path: 'A.bundle', real_path: 'b/A.bundle')
      mock_bundle_b = mock('BundleFileRef').stubs(path: 'B.bundle', real_path: 'b/B.bundle')
      section = XCRes::Section.new('A', { 'a' => 'a.gif' })
      @analyzer.expects(:find_file_refs_by_extname).returns([mock_bundle_a, mock_bundle_b])
      @analyzer.expects(:build_section_for_bundle).with(mock_bundle_a).returns(section)
      @analyzer.expects(:build_section_for_bundle).with(mock_bundle_b).returns(nil)
      @analyzer.build_sections_for_bundles.should.be.eql?([section])
    end
  end

  describe '#build_section_for_bundle' do
    before do
      @mock_bundle = mock('Bundle') { stubs(path: 'A.bundle', real_path: 'b/A.bundle') }
    end

    describe 'Images' do

      before do
        @options = { linked_resources: [ XCRes::ResourceTypes::ImageResource.new ] }
        @analyzer = subject.new(nil, @options)
        @analyzer.logger = stub('Logger', :log)
      end

      it 'should return nil if the bundle does not contain any images' do
        @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.m')])
        @analyzer.build_section_for_bundle(@mock_bundle).items['Images'].items.should.be.empty?
      end

      it 'should return nil if the bundle does not contain any valid images' do
        @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.gif')])
        @analyzer.exclude_file_patterns = ['a.gif']
        @analyzer.build_section_for_bundle(@mock_bundle).items['Images'].items.should.be.empty?
      end

      it 'should build a new section if the bundle contain valid images' do
        @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.gif')])
        @analyzer.build_section_for_bundle(@mock_bundle).items['Images'].should.be.eql?(XCRes::Section.new('Images', {'a' => 'a.gif'}, @options))
      end

      it 'should return nil for other kinds of sections' do
        @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.gif')])
        @analyzer.build_section_for_bundle(@mock_bundle).items.has_key?('Sounds').should.be.false
      end

    end

    describe 'Sounds' do

      before do
        @options = { linked_resources: [ XCRes::ResourceTypes::SoundResource.new ] }
        @analyzer = subject.new(nil, @options)
        @analyzer.logger = stub('Logger', :log)
      end

      it 'should return nil if the bundle does not contain any sounds' do
        @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.m')])
        @analyzer.build_section_for_bundle(@mock_bundle).items['Sounds'].items.should.be.empty
      end

      it 'should return nil if the bundle does not contain any valid sounds' do
        @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.caf')])
        @analyzer.exclude_file_patterns = ['a.caf']
        @analyzer.build_section_for_bundle(@mock_bundle).items['Sounds'].items.should.be.empty
      end

      it 'should build a new section if the bundle contains valid sounds' do
        @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.caf')])
        @analyzer.build_section_for_bundle(@mock_bundle).items['Sounds'].should.be.eql?(XCRes::Section.new('Sounds', {'a' => 'a.caf'}, @options))
      end

      it 'should return nil for other kinds of sections' do
        @analyzer.expects(:find_files_in_dir).with(@mock_bundle.real_path).returns([Pathname('a.caf')])
        @analyzer.build_section_for_bundle(@mock_bundle).items.has_key?('Images').should.be.false
      end

    end


  end

end
