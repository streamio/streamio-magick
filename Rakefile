require 'bundler'
Bundler.require

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec') do |t|
  t.pattern = FileList['spec/**/*_spec.rb']
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
  sh "rm streamio-ffmpeg-#{Magick::VERSION}.gem"
end