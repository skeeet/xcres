require File.expand_path('../../../spec_helper', __FILE__)

describe 'XCRes::ResourceTypes::ImageXCAssetResource' do

  def subject
    XCRes::ResourceTypes::ImageXCAssetResource
  end

  before do
    @type = subject.new
  end

  describe '#filter_words' do
    it 'should return a correct #filter_words for this type' do
      @type.filter_words.should.be.eql?(['icon', 'image'])
    end
  end

  describe '#filter_files' do
    it 'should filter filepaths to only a set of relevant ones' do
      filtered = @type.filter_files([
        'folder/good_file.appiconset',
        'folder/good_file.imageset',
        'folder/good_file.launchimage',
        'folder/bad_file.png',
        'folder/bad_file.jpg',
        'folder/bad_file.jpeg',
        'folder/bad_file.gif',
        'folder/bad_file.ext',
        'folder/bad_file',
        'good_file.appiconset',
        'good_file.imageset',
        'good_file.launchimage',
        'bad_file.ext',
        'bad_file.png',
        'bad_file.jpg',
        'bad_file.jpeg',
        'bad_file.gif',
        'bad_file',
        ])
      filtered.should.be.eql?([
        'folder/good_file.appiconset',
        'folder/good_file.imageset',
        'folder/good_file.launchimage',
        'good_file.appiconset',
        'good_file.imageset',
        'good_file.launchimage',     
          ])
    end
  end

  describe '#match_file' do
    it 'should correctly recognize the link between the given file and current resource type' do
      @type.match_file('folder/good_file.appiconset').should.be.eql?(true)
      @type.match_file('folder/good_file.imageset').should.be.eql?(true)
      @type.match_file('folder/good_file.launchimage').should.be.eql?(true)
      @type.match_file('folder/bad_file.ext').should.be.eql?(false)
      @type.match_file('folder/bad_file').should.be.eql?(false)
      @type.match_file('good_file.appiconset').should.be.eql?(true)
      @type.match_file('good_file.imageset').should.be.eql?(true)
      @type.match_file('good_file.launchimage').should.be.eql?(true)
      @type.match_file('bad_file.ext').should.be.eql?(false)
      @type.match_file('bad_file').should.be.eql?(false)
    end

    it 'should not recognize the plain image files as a linked resource' do
      @type.match_file('folder/bad_file.png').should.be.eql?(false)
      @type.match_file('folder/bad_file.jpg').should.be.eql?(false)
      @type.match_file('folder/bad_file.jpeg').should.be.eql?(false)
      @type.match_file('folder/bad_file.gif').should.be.eql?(false)
      @type.match_file('bad_file.png').should.be.eql?(false)
      @type.match_file('bad_file.jpg').should.be.eql?(false)
      @type.match_file('bad_file.jpeg').should.be.eql?(false)
      @type.match_file('bad_file.gif').should.be.eql?(false)
    end
  end

  describe '#resource_type' do
    it 'should return a correct human-readable type of the resource class' do
      @type.resource_type.should.be.eql?('Images')
    end
  end
end