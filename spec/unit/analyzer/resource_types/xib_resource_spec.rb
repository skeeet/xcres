require File.expand_path('../../../spec_helper', __FILE__)

describe 'XCRes::ResourceTypes::XIBResource' do

  def subject
    XCRes::ResourceTypes::XIBResource
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
        'folder/good_file.xib',
        'folder/bad_file.ext',
        'folder/bad_file.storyboard',
        'folder/bad_file',
        'good_file.xib',
        'bad_file.ext',
        'bad_file.storyboard',
        'bad_file',
        ])
      filtered.should.be.eql?([
        'folder/good_file.xib',
        'good_file.xib',      
          ])
    end
  end

  describe '#match_file' do
    it 'should correctly recognize the link between the given file and current resource type' do
      @type.match_file('folder/good_file.xib').should.be.eql?(true)
      @type.match_file('folder/bad_file.ext').should.be.eql?(false)
      @type.match_file('folder/bad_file').should.be.eql?(false)
      @type.match_file('good_file.xib').should.be.eql?(true)
      @type.match_file('bad_file.ext').should.be.eql?(false)
      @type.match_file('bad_file').should.be.eql?(false)
    end

    it 'should not recognize the storyboard types' do
      @type.match_file('folder/bad_file.storyboard').should.be.eql?(false)
      @type.match_file('bad_file.storyboard').should.be.eql?(false)
    end
  end

  describe '#resource_type' do
    it 'should return a correct human-readable type of the resource class' do
      @type.resource_type.should.be.eql?('Nibs')
    end
  end
end