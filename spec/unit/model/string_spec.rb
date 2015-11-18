require File.expand_path('../../spec_helper', __FILE__)

describe 'XCRes::String' do

  def subject
    XCRes::String
  end

  describe '#initialize' do
    it 'should initialize a new string' do
      section = subject.new('test_key', 'test_value', 'test_comment')
      section.key.should.be.eql?('test_key')
      section.value.should.be.eql?('test_value')
      section.comment.should.be.eql?('test_comment')
    end
  end

  describe '#==' do
    before do
      @left = subject.new('test_key', 'test_value', 'test_comment')
    end

    it 'should be true for equal strings' do
      (@left == subject.new('test_key', 'test_value', 'test_comment')).should.be.true?
    end

    it 'should be false if key is different' do
      (@left == subject.new('test_key2', 'test_value', 'test_comment')).should.be.false?
    end

    it 'should be false if values are different' do
      (@left == subject.new('test_key', 'test_value2', 'test_comment')).should.be.false?
    end

    it 'should be false if comments are different' do
      (@left == subject.new('test_key', 'test_value', 'test_comment2')).should.be.false?
    end
  end

end
