require 'rubygems'
require 'rubygems/package_task'
require 'rubygems/specification'
require 'date'
require 'yard'

gemspec = eval(IO.read("ohai.gemspec"))


Gem::PackageTask.new(gemspec).define

desc "install the gem locally"
task :install => [:package] do
  sh %{gem install pkg/#{ohai}-#{OHAI_VERSION}}
end

YARD::Rake::YardocTask.new do |doc|
   doc.files = ['lib/*.rb', 'lib/ohai/*.rb', 'lib/ohai/mixin/*.rb',
                'bin/ohai', '-', 'README.rdoc']
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new do |t|
    t.pattern = 'spec/**/*_spec.rb'
  end
rescue LoadError
  desc "rspec is not installed, this task is disabled"
  task :spec do
    abort "rspec is not installed. `(sudo) gem install rspec` to run unit tests"
  end
end

task :default => :spec
