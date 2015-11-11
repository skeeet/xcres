require File.expand_path('../../../spec_helper', __FILE__)

describe 'XCRes::CollectionsAnalyzer::BaseCollectionsAnalyzer' do

  def subject
    XCRes::CollectionsAnalyzer::BaseCollectionsAnalyzer
  end

  describe '#initialize' do
    it 'should initialize with empty params' do
      subject.new.target.should.eql?(nil)
    end

    it 'should initialize with empty options' do
      a = subject.new("test")
      a.target.should.eql?("test")
      a.linked_resources.should.eql?(nil)
    end

    it 'should initialize with one resource' do
      res = XCRes::ResourceTypes::ImageResource.new
      a = subject.new(nil, {
        :linked_resources => [ res ]
      })
      a.linked_resources.should.eql?([ res ])
    end

    it 'should initialize with multiple resources' do
      res1 = XCRes::ResourceTypes::ImageResource.new
      res2 = XCRes::ResourceTypes::SoundResource.new
      a = subject.new(nil, {
        :linked_resources => [ res1, res2 ]
      })
      a.linked_resources.should.eql?([ res1, res2 ])
    end
  end

  describe '#find_files_in_dir' do
    # TODO: Test using fakefs, ...
  end

  # describe '#build_images_section_data' do
  #   it 'returns an empty hash if no files were given' do
  #     @analyzer.build_images_section_data([]).should.eql?({})
  #   end

  #   describe 'option use_basename is not given' do
  #     it 'builds an items hash and keep the path' do
  #       @analyzer.build_images_section_data([Pathname('b/a.m'), Pathname('b/a.gif')])
  #         .should.eql?({ 'b/a' => 'b/a.gif' })
  #     end
  #   end

  #   describe 'option use_basename is given as []' do
  #     it 'builds an items hash and keep the path' do
  #       @analyzer.build_images_section_data([Pathname('b/a.m'), Pathname('b/a.gif')], use_basename: [])
  #         .should.eql?({ 'b/a' => 'b/a.gif' })
  #     end
  #   end

  #   describe 'option use_basename is given as [:key]' do
  #     it 'builds an items hash and remove the path' do
  #       @analyzer.build_images_section_data([Pathname('b/a.m'), Pathname('b/a.gif')], use_basename: [:key])
  #         .should.eql?({ 'a' => 'b/a.gif' })
  #     end
  #   end

  #   describe 'option use_basename is given as [:path]' do
  #     it 'builds an items hash and remove the path' do
  #       @analyzer.build_images_section_data([Pathname('b/a.m'), Pathname('b/a.gif')], use_basename: [:path])
  #         .should.eql?({ 'b/a' => 'a.gif' })
  #     end
  #   end

  #   describe 'option use_basename is given as [:key,:path]' do
  #     it 'builds an items hash and remove the path' do
  #       @analyzer.build_images_section_data([Pathname('b/a.m'), Pathname('b/a.gif')], use_basename: [:key, :path])
  #         .should.eql?({ 'a' => 'a.gif' })
  #     end
  #   end
  # end


  # describe '#find_image_files' do
  #   it 'returns a empty list if no files were given' do
  #     @analyzer.find_image_files([]).should.eql?([])
  #   end

  #   it 'matches common image formats' do
  #     @analyzer.find_image_files(['a.png', 'b.jpg', 'c.jpeg', 'd.gif', 'e.txt'])
  #                    .should.eql?(['a.png', 'b.jpg', 'c.jpeg', 'd.gif'])
  #   end
  # end

  describe '#build_section_data' do
    before do
      @analyzer = subject.new
      @resource_type = XCRes::ResourceTypes::ImageResource.new
      @analyzer.logger = stub('Logger', :log)
      @file_paths = [Pathname('a/b')]
    end

    it 'returns an empty hash if no file paths given' do
      @analyzer.build_section_data([], @resource_type).should.be.eql?({})
    end

    it 'returns a hash with the basename if option use_basename is [:key]' do
      @analyzer.expects(:key_from_path).with('b', @resource_type).returns('b')
      @analyzer.build_section_data(@file_paths, @resource_type, use_basename: [:key])
        .should.be.eql?({ 'b' => 'a/b' })
    end

    it 'returns a hash with the basename if option use_basename is [:path]' do
      @analyzer.expects(:key_from_path).with('a/b', @resource_type).returns('a/b')
      @analyzer.build_section_data(@file_paths, @resource_type, use_basename: [:path])
        .should.be.eql?({ 'a/b' => 'b' })
    end

    it 'returns a hash with the basename if option use_basename is [:key, :path]' do
      @analyzer.expects(:key_from_path).with('b', @resource_type).returns('b')
      @analyzer.build_section_data(@file_paths, @resource_type, use_basename: [:key, :path])
        .should.be.eql?({ 'b' => 'b' })
    end

    it 'returns a hash with relative paths if option use_basename is []' do
      @analyzer.expects(:key_from_path).with('a/b', @resource_type).returns('a/b')
      @analyzer.build_section_data(@file_paths, @resource_type, use_basename: [])
        .should.be.eql?({ 'a/b' => 'a/b' })
    end

    it 'returns a hash with relative paths if option use_basename is not given' do
      @analyzer.expects(:key_from_path).with('a/b', @resource_type).returns('a/b')
      @analyzer.build_section_data(@file_paths, @resource_type)
        .should.be.eql?({ 'a/b' => 'a/b' })
    end
  end

  describe '#key_from_path' do
    describe 'Images' do
      before do
        @resource_type = XCRes::ResourceTypes::ImageResource.new
        @analyzer = subject.new
        @analyzer.logger = stub('Logger', :log)
      end

      it 'should keep the path' do
        @analyzer.key_from_path('b/a', @resource_type).should.be.eql?('b/a')
      end

      it 'should cut the file extension' do
        @analyzer.key_from_path('a.gif', @resource_type).should.be.eql?('a')
      end

      it 'should cut only the last file extension' do
        @analyzer.key_from_path('a.gif.gif', @resource_type).should.be.eql?('a.gif')
      end

      it 'should transform camel case to snake case' do
        @analyzer.key_from_path('AbCdEf', @resource_type).should.be.eql?('ab_cd_ef')
      end

      it 'should filter certain words' do
        @analyzer.key_from_path('my_icon_catImage', @resource_type).should.be.eql?('my_cat')
      end

      it 'should not contain unnecessary underscores' do
        @analyzer.key_from_path('__a___b__c___', @resource_type).should.be.eql?('a_b_c')
      end
    end

    describe 'Sounds' do
      before do
        @resource_type = XCRes::ResourceTypes::SoundResource.new
        @analyzer = subject.new
        @analyzer.logger = stub('Logger', :log)
      end

      it 'should keep the path' do
        @analyzer.key_from_path('b/a', @resource_type).should.be.eql?('b/a')
      end

      it 'should cut the file extension' do
        @analyzer.key_from_path('a.caf', @resource_type).should.be.eql?('a')
      end

      it 'should cut only the last file extension' do
        @analyzer.key_from_path('a.caf.caf', @resource_type).should.be.eql?('a.caf')
      end

      it 'should transform camel case to snake case' do
        @analyzer.key_from_path('AbCdEf', @resource_type).should.be.eql?('ab_cd_ef')
      end

      it 'should filter certain words' do
        @analyzer.key_from_path('my_sound_catMusic', @resource_type).should.be.eql?('my_cat')
      end

      it 'should not contain unnecessary underscores' do
        @analyzer.key_from_path('__a___b__c___', @resource_type).should.be.eql?('a_b_c')
      end
    end
  end

end
