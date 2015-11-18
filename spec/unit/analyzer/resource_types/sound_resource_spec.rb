require File.expand_path('../../../spec_helper', __FILE__)

describe 'XCRes::ResourceTypes::SoundResource' do

  def subject
    XCRes::ResourceTypes::SoundResource
  end

  before do
    @type = subject.new
  end

  describe '#filter_words' do
    it 'should return a correct #filter_words for this type' do
      @type.filter_words.should.be.eql?(['sound', 'melody', 'music'])
    end
  end

  describe '#filter_files' do
    it 'should filter filepaths to only a set of relevant ones' do
      filtered = @type.filter_files([
        'folder/good_file.caf',
        'folder/good_file.raw',
        'folder/good_file.wav',
        'folder/good_file.aiff',
        'folder/good_file.aif',
        'folder/good_file.mp3',
        'folder/bad_file.ext',
        'folder/bad_file',
        'good_file.caf',
        'good_file.raw',
        'good_file.wav',
        'good_file.aiff',
        'good_file.aif',
        'good_file.mp3',
        'bad_file.ext',
        'bad_file',
        ])
      filtered.should.be.eql?([
        'folder/good_file.caf',
        'folder/good_file.raw',
        'folder/good_file.wav',
        'folder/good_file.aiff',
        'folder/good_file.aif',
        'folder/good_file.mp3',
        'good_file.caf',
        'good_file.raw',
        'good_file.wav',
        'good_file.aiff',
        'good_file.aif',
        'good_file.mp3',     
          ])
    end
  end

  describe '#match_file' do
    it 'should correctly recognize the link between the given file and current resource type' do
      @type.match_file('folder/good_file.caf').should.be.eql?(true)
      @type.match_file('folder/good_file.raw').should.be.eql?(true)
      @type.match_file('folder/good_file.wav').should.be.eql?(true)
      @type.match_file('folder/good_file.aiff').should.be.eql?(true)
      @type.match_file('folder/good_file.aif').should.be.eql?(true)
      @type.match_file('folder/good_file.mp3').should.be.eql?(true)
      @type.match_file('folder/bad_file.ext').should.be.eql?(false)
      @type.match_file('folder/bad_file').should.be.eql?(false)
      @type.match_file('good_file.caf').should.be.eql?(true)
      @type.match_file('good_file.raw').should.be.eql?(true)
      @type.match_file('good_file.wav').should.be.eql?(true)
      @type.match_file('good_file.aiff').should.be.eql?(true)
      @type.match_file('good_file.aif').should.be.eql?(true)
      @type.match_file('good_file.mp3').should.be.eql?(true)
      @type.match_file('bad_file.ext').should.be.eql?(false)
      @type.match_file('bad_file').should.be.eql?(false)
    end
  end

  describe '#resource_type' do
    it 'should return a correct human-readable type of the resource class' do
      @type.resource_type.should.be.eql?('Sounds')
    end
  end
end