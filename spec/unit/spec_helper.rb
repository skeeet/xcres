require 'bacon'
require 'pretty_bacon'
require 'mocha-on-bacon'
require 'xcres'
require 'pathname'

def fixture_path
  @fixture_path ||= Pathname(File.expand_path('../../fixtures', __FILE__))
end

def xcodeproj
  Xcodeproj::Project.open(fixture_path + 'Example/Example.xcodeproj')
end

def xcodeproj_osx
  Xcodeproj::Project.open(fixture_path + 'ExampleOSX/ExampleOSX.xcodeproj')
end

def app_target
  xcodeproj.targets.find { |t| t.name == 'Example' }
end

def app_target_osx
  xcodeproj_osx.targets.find { |t| t.name == 'ExampleOSX' }
end
