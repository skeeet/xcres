require File.expand_path('../../../spec_helper', __FILE__)

describe 'XCRes::ResourceTypes::ImageResource' do

  def subject
    XCRes::ResourceTypes::ImageResource
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
        'folder/good_file.png',
        'folder/good_file.jpg',
        'folder/good_file.jpeg',
        'folder/good_file.gif',
        'folder/bad_file.ext',
        'folder/bad_file.appiconset',
        'folder/bad_file.imageset',
        'folder/bad_file.launchimage',
        'folder/bad_file',
        'good_file.png',
        'good_file.jpg',
        'good_file.jpeg',
        'good_file.gif',
        'bad_file.ext',
        'bad_file.appiconset',
        'bad_file.imageset',
        'bad_file.launchimage',
        'bad_file',
        ])
      filtered.should.be.eql?([
        'folder/good_file.png',
        'folder/good_file.jpg',
        'folder/good_file.jpeg',
        'folder/good_file.gif',
        'good_file.png',
        'good_file.jpg',
        'good_file.jpeg',
        'good_file.gif',       
          ])
    end
  end

  describe '#match_file' do
    it 'should correctly recognize the link between the given file and current resource type' do
      @type.match_file('folder/good_file.png').should.be.eql?(true)
      @type.match_file('folder/good_file.jpg').should.be.eql?(true)
      @type.match_file('folder/good_file.jpeg').should.be.eql?(true)
      @type.match_file('folder/good_file.gif').should.be.eql?(true)
      @type.match_file('folder/bad_file.ext').should.be.eql?(false)
      @type.match_file('folder/bad_file').should.be.eql?(false)
      @type.match_file('good_file.png').should.be.eql?(true)
      @type.match_file('good_file.jpg').should.be.eql?(true)
      @type.match_file('good_file.jpeg').should.be.eql?(true)
      @type.match_file('good_file.gif').should.be.eql?(true)
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
      @type.resource_type.should.be.eql?('Images')
    end
  end
  
  describe '#filter_device_specific_image_paths' do
    it 'returns an empty list if no files were given' do
      @type.filter_device_specific_image_paths([]).should.eql?([])
    end

    it 'filters device scale specific images without doublets' do
      @type.filter_device_specific_image_paths(['a.png', 'a@2x.png']).should.eql?(['a.png'])
    end

    it 'filters device scale specifiers from image paths' do
      @type.filter_device_specific_image_paths(['a@2x.png']).should.eql?(['a.png'])
    end

    it 'filters idiom specific images without doublets' do
      @type.filter_device_specific_image_paths(['a.png', 'a~iphone.png', 'a~ipad.png']).should.eql?(['a.png'])
    end

    it 'filters idiom specifiers from image paths' do
      @type.filter_device_specific_image_paths(['a~iphone.png']).should.eql?(['a.png'])
      @type.filter_device_specific_image_paths(['a~ipad.png']).should.eql?(['a.png'])
    end
  end
end