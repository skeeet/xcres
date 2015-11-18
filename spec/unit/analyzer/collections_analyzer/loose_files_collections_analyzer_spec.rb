require File.expand_path('../../../spec_helper', __FILE__)

describe 'XCRes::ResourcesAnalyzer::LooseFilesCollectionsAnalyzer' do

  def subject
    XCRes::CollectionsAnalyzer::LooseFilesCollectionsAnalyzer
  end

  before do
    @analyzer = subject.new
    @analyzer.logger = stub('Logger', :log)
  end

  describe '#analyze' do
    # TODO
  end

  describe '#build_section_for_loose_images' do
    # TODO
  end

end
