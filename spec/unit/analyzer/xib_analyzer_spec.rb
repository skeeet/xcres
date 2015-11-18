require File.expand_path('../../spec_helper', __FILE__)
# require 'xcres/analyzer/xib_analyzer'

describe 'XCRes::XIBAnalyzer' do

  def subject
    XCRes::XIBAnalyzer
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
    it 'should return an empty section if there are no xib files' do
      @analyzer.stubs(:xib_file_refs).returns([])
      @analyzer.build_section.should.be.eql?(XCRes::Section.new 'ReuseIdentifiers', {})
    end

    it 'should return an empty section if there are xib files but no reuse identifiers found' do
      @analyzer.stubs(:xib_file_refs).returns([])
      @analyzer.build_section.should.be.eql?(XCRes::Section.new 'ReuseIdentifiers', {})
    end

    it 'should return a new section if there are xib files with reuse identifiers found' do
      xib_file_ref = stub('FileRef', {
        name:      'TestView',
        path:      'TestView.xib',
        real_path: Pathname(File.expand_path('./TestView.xib'))
      })
      @analyzer.stubs(:xib_file_refs).returns([xib_file_ref])
      @analyzer.stubs(:keys_by_file)
        .with(Pathname('TestView.xib'))
        .returns({
          'id1' => 'Id1',
          'id2' => 'Id2' 
        })
      @analyzer.build_section.should.be.eql?(XCRes::Section.new('ReuseIdentifiers', { 'TestView' => XCRes::Section.new('TestView', {
        'id1' => 'Id1',
        'id2' => 'Id2' 
      })}))
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

    describe "#xib_file_refs" do
      it 'should return the xib files of the fixture project' do
        xib_files = @analyzer.xib_file_refs
        xib_files.count.should.be.eql?(1)
        xib_files[0].path.should.be.eql?('TestView.xib')
      end
    end

    describe "complete reuse identifiers section" do
      it 'should return a section build for all reuse identifiers in all xib files' do
        path = fixture_path + 'Example/Example/TestView.xib'
        @analyzer.build_section.should.be.eql?(XCRes::Section.new('ReuseIdentifiers', { 'TestView' => XCRes::Section.new('TestView', {
          'test_view_xib' => 'TestViewXib'
        })}))
      end
    end
  end

  describe "#read_xib_file" do
    it 'should read a valid file' do
      path = fixture_path + 'Example/Example/TestView.xib'
      file_contents = File.read(path)
      @analyzer.read_xib_file(path).should == file_contents
    end

    it 'should raise an error for not existing file file' do
      proc do
        @analyzer.read_xib_file(fixture_path + 'Example/Example/NotExisting.xib')
      end.should.raise(ArgumentError).message.should.include "doesn't exist"
    end
  end

  describe "#keys_by_file" do
    it 'should return the reuse identifier hash for given xib' do
      path = fixture_path + 'Example/Example/TestView.xib'
      @analyzer.keys_by_file(path).should == { 'test_view_xib' => 'TestViewXib' }
    end
  end

end
