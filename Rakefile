$LOAD_PATH.unshift 'lib'

require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

task :default => :spec

desc "Push a new version to Rubygems"
task :publish do
  require 'magick/version'

  sh "gem build streamio-magick.gemspec"
  sh "gem push streamio-magick-#{Magick::VERSION}.gem"
  sh "git tag v#{Magick::VERSION}"
  sh "git push origin v#{Magick::VERSION}"
  sh "git push origin master"
  sh "git clean -fd"
end