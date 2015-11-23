require File.expand_path('../../spec_helper', __FILE__)

describe 'XCRes::IBAnalyzer' do

  def subject
    XCRes::IBAnalyzer
  end

  before do
    @target = stub('Target', build_configurations: [])
    @project = stub('Project', files: [], path: Pathname('.'))
    @target.stubs(project: @project)

    @analyzer = subject.new(@target)
    @analyzer.logger = stub('Logger', :log)
    @analyzer.expects(:warn).never
    @analyzer.expects(:error).never
  end

  describe "#initialize" do
    it 'should set given target as attribute' do
      @analyzer = subject.new(@target)
      @analyzer.target.should.be.eql?(@target)
      @analyzer.project.should.be.eql?(@project)
    end
  end

  describe "#analyze" do
    it 'should return the built sections' do
      section = mock()
      @analyzer.expects(:build_sections).returns([section])
      @analyzer.analyze.should.be.eql?([section])
    end
  end

  describe "#build_sections" do
    it 'should return no sections if there are no xib files' do
      @analyzer.stubs(:ib_file_refs).returns([])
      @analyzer.build_sections.should.be.eql?([])
    end

    it 'should return no sections if there are xib files but no reuse identifiers found' do
      @analyzer.stubs(:ib_file_refs).returns([])
      @analyzer.build_sections.should.be.eql?([])
    end

    it 'should return reuse identifiers only if it is a xib' do
      ib_file_ref = stub('FileRef', {
        name:      'TestView',
        path:      'TestView.xib',
        real_path: Pathname(File.expand_path('./TestView.xib'))
      })
      @analyzer.stubs(:ib_file_refs).returns([ib_file_ref])
      @analyzer.stubs(:read_ib_file).returns('')
      @analyzer.stubs(:find_elements)
        .returns({
          'id1' => 'Id1',
          'id2' => 'Id2' 
        })
      @analyzer.build_sections.should.be.eql?([
        XCRes::Section.new('ReuseIdentifiers', { 'TestView' => XCRes::Section.new('TestView', {
          'id1' => 'Id1',
          'id2' => 'Id2' 
        })}),
        XCRes::Section.new('RestorationIdentifiers', { 'TestView' => XCRes::Section.new('TestView', {
          'id1' => 'Id1',
          'id2' => 'Id2' 
        })})
      ])
    end

    it 'should return reuse identifiers, storyboard and segue ids if it is a storyboard' do
      ib_file_ref = stub('FileRef', {
        name:      'TestView',
        path:      'TestView.storyboard',
        real_path: Pathname(File.expand_path('./TestView.storyboard'))
      })
      @analyzer.stubs(:ib_file_refs).returns([ib_file_ref])
      @analyzer.stubs(:read_ib_file).returns('')
      @analyzer.stubs(:find_elements)
        .returns({
          'id1' => 'Id1'
        })
      @analyzer.build_sections.should.be.eql?([
        XCRes::Section.new('ReuseIdentifiers', { 'TestView' => XCRes::Section.new('TestView', {
        'id1' => 'Id1'
        })}),
        XCRes::Section.new('SegueIdentifiers', { 'TestView' => XCRes::Section.new('TestView', {
        'id1' => 'Id1'
        })}),
        XCRes::Section.new('StoryboardIdentifiers', { 'TestView' => XCRes::Section.new('TestView', {
        'id1' => 'Id1'
        })}),
        XCRes::Section.new('RestorationIdentifiers', { 'TestView' => XCRes::Section.new('TestView', {
        'id1' => 'Id1'
        })})
      ])
    end

  end

  describe "with fixture project" do
    before do
      @target = app_target
      @analyzer = subject.new(@target)
      @analyzer.logger = stub('Logger', :log)
      @analyzer.expects(:warn).never
      @analyzer.expects(:error).never
    end

    describe "#ib_file_refs" do
      it 'should return the ib files of the fixture project' do
        ib_files = @analyzer.ib_file_refs
        ib_files.count.should.be.eql?(4)
        ib_files[0].path.should.be.eql?('TestView.xib')
        ib_files[1].path.should.be.eql?('TestMyStoryboard.storyboard')
        ib_files[2].path.should.be.eql?('TestMyScene.storyboard')
        ib_files[3].path.should.be.eql?('OtherName.storyboard')
      end
    end

    describe "complete identifiers sections" do
      it 'should return a section build for all reuse identifiers in all xib files' do
        path = fixture_path + 'Example/Example/TestView.xib'
        @analyzer.build_sections.should.be.eql?([
          XCRes::Section.new('ReuseIdentifiers', { 
            'TestView' => XCRes::Section.new('TestView', {
              'test_view_xib' => 'TestViewXib'
            }),
            'TestMyStoryboard' => XCRes::Section.new('TestMyStoryboard', {
              'test_my_storyboard' => 'TestMyStoryboard'
            }),
            'TestMyScene' => XCRes::Section.new('TestMyScene', {
              'test_my_scene' => 'TestMyScene'
            }),
            'OtherName' => XCRes::Section.new('OtherName', {
              'other_name' => 'OtherName'
            })
          })
        ])
      end
    end
  end

  describe "#read_ib_file" do
    it 'should read a valid file' do
      path = fixture_path + 'Example/Example/TestView.xib'
      file_contents = File.read(path)
      @analyzer.read_ib_file(path).should == file_contents
    end

    it 'should raise an error for not existing file file' do
      proc do
        @analyzer.read_ib_file(fixture_path + 'Example/Example/NotExisting.xib')
      end.should.raise(ArgumentError).message.should.include "doesn't exist"
    end
  end

  describe "#find_elements" do
    it 'should return the reuse identifier hash for given xml' do
      path = fixture_path + 'Example/Example/TestView.xib'
      xml = Nokogiri::XML(path)
      @analyzer.find_elements(xml, 'tableViewCell', 'reuseIdentifier').should == { 'test_view_xib' => 'TestViewXib' }
    end
  end

end
