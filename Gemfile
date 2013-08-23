source 'https://rubygems.org'

# alternative graphing gem
gem "googlecharts"
group :development, :test do
  # includes rake, rspec, simplecov
  gem 'devtools', git: 'https://github.com/rom-rb/devtools.git'
end
group :development do

end
group :test do
  gem 'test-construct'
  # https://github.com/kina/simplecov-rcov-text
  gem 'simplecov-rcov-text'
  gem "fakefs", :require => "fakefs/safe"
  gem 'json'
end
gemspec :path => File.expand_path('..', __FILE__)

# Added by devtools
eval_gemfile 'Gemfile.devtools'
