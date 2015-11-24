require File.expand_path('../../spec_helper', __FILE__)

describe 'XCRes::FontAnalyzer' do

  def subject
    XCRes::FontAnalyzer
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
      @analyzer.expects(:build_section).returns(section)
      @analyzer.analyze.should.be.eql?([section])
    end
  end

  describe "#build_section" do
    it 'should return empty section if there are no font files' do
      @analyzer.stubs(:font_file_refs).returns([])
      @analyzer.build_section.should.be.eql?(XCRes::Section.new('Fonts', {}))
    end

    it 'should return full section' do
      ttf_file_ref = stub('FileRef', {
        name:      'TestFont',
        path:      'TestFont.ttf',
        real_path: Pathname(File.expand_path('./TestFont.ttf'))
      })
      @analyzer.stubs(:font_file_refs).returns([ttf_file_ref])
      @analyzer.stubs(:postscript_name_from_file).returns('TestFontPostScript')
      @analyzer.build_section.should.be.eql?(XCRes::Section.new('Fonts', { 'TestFont' => 'TestFontPostScript' }))
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

    describe "#font_file_refs" do
      it 'should return the ib files of the fixture project' do
        ib_files = @analyzer.font_file_refs
        ib_files.count.should.be.eql?(2)
        ib_files[0].path.should.be.eql?('ProximaNova-BoldItalic.otf')
        ib_files[1].path.should.be.eql?('YourSignature.ttf')
      end
    end

    describe "complete identifiers sections" do
      it 'should return a section build for all fonts' do
        @analyzer.build_section.should.be.eql?(
          XCRes::Section.new('Fonts', {
            'ProximaNova-BoldItalic' => 'ProximaNova-BoldIt',
            'YourSignature' => 'YourSignature'
          })
        )
      end
    end
  end

  describe "#postscript_name_from_file" do
    it 'should return the post script name of a font file' do
      path = Pathname(fixture_path + 'Example/Example/YourSignature.ttf')
      @analyzer.postscript_name_from_file(path).should == 'YourSignature'
      path = Pathname(fixture_path + 'Example/Example/ProximaNova-BoldItalic.otf')
      @analyzer.postscript_name_from_file(path).should == 'ProximaNova-BoldIt'
    end
  end

end
