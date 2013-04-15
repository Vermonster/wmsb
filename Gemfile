source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'haml'
gem 'faraday'
gem 'active_model_serializers'
gem 'unicorn'
gem 'dalli'
gem 'simple_form'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bourbon'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'haml_coffee_assets'
  gem 'jquery-rails'
end

group :production do
  gem 'memcachier'
end

group :development do
  gem 'thin'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'timecop'
end

group :development, :test do
  gem 'foreman'
  gem 'jasmine'
  gem 'jasminerice'
  gem 'guard-jasmine'
  gem 'pry-rails'
end
