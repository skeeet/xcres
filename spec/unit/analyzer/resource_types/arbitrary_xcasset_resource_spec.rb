require File.expand_path('../../../spec_helper', __FILE__)

describe 'XCRes::ResourceTypes::ArbitraryXCAssetResource' do

  def subject
    XCRes::ResourceTypes::ArbitraryXCAssetResource
  end

  before do
    @type = subject.new
  end

  describe '#filter_words' do
    it 'should return a correct #filter_words for this type' do
      @type.filter_words.should.be.eql?([])
    end
  end

  describe '#filter_files' do
    it 'should filter filepaths to only a set of relevant ones' do
      filtered = @type.filter_files([
        'folder/good_file.dataset',
        'folder/bad_file.ext',
        'folder/bad_file.appiconset',
        'folder/bad_file.imageset',
        'folder/bad_file.launchimage',
        'folder/bad_file',
        'good_file.dataset',
        'bad_file.ext',
        'bad_file.appiconset',
        'bad_file.imageset',
        'bad_file.launchimage',
        'bad_file',
        ])
      filtered.should.be.eql?([
        'folder/good_file.dataset',
        'good_file.dataset',          
          ])
    end
  end

  describe '#match_file' do
    it 'should correctly recognize the link between the given file and current resource type' do
      @type.match_file('folder/good_file.dataset').should.be.eql?(true)
      @type.match_file('folder/bad_file.ext').should.be.eql?(false)
      @type.match_file('folder/bad_file').should.be.eql?(false)
      @type.match_file('good_file.dataset').should.be.eql?(true)
      @type.match_file('bad_file.ext').should.be.eql?(false)
      @type.match_file('bad_file').should.be.eql?(false)
    end

    it 'should not recognize the xcasset image types' do
      @type.match_file('folder/bad_file.appiconset').should.be.eql?(false)
      @type.match_file('folder/bad_file.imageset').should.be.eql?(false)
      @type.match_file('folder/bad_file.launchimage').should.be.eql?(false)
      @type.match_file('bad_file.appiconset').should.be.eql?(false)
      @type.match_file('bad_file.imageset').should.be.eql?(false)
      @type.match_file('bad_file.launchimage').should.be.eql?(false)
    end
  end

  describe '#resource_type' do
    it 'should return a correct human-readable type of the resource class' do
      @type.resource_type.should.be.eql?('Data')
    end
  end
end