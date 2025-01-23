# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.4'

gem 'rails', '~> 7.0.8', '>= 7.0.8.6'

gem 'activeadmin', '~> 3.2', '>= 3.2.5'
gem 'active_storage_validations', '~> 1.1', '>= 1.1.4'
gem 'arctic_admin', '~> 4.3', '>= 4.3.1'
gem 'blueprinter', '~> 1.1', '>= 1.1.2'
gem 'bootsnap', require: false
gem 'devise', '~> 4.9'
gem 'devise-jwt', '~> 0.12.1'
gem 'pagy', '~> 9.3'
gem 'pg', '~> 1.1'
gem 'pg_search', '~> 2.3', '>= 2.3.6'
gem 'puma', '~> 5.0'
gem 'rack-cors', '~> 2.0', '>= 2.0.2'
gem 'sassc-rails', '~> 2.1', '>= 2.1.2'
gem 'sprockets-rails', '~> 3.5', '>= 3.5.2'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 3.1', '>= 3.1.4'
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.4'
  gem 'faker', '~> 3.5', '>= 3.5.1'
  gem 'rspec-rails', '~> 7.0', '>= 7.0.1'
  gem 'rubocop', '~> 1.68'
  gem 'rubocop-rails', '~> 2.27'
  gem 'shoulda-matchers', '~> 6.4'
end

group :development do
  gem 'letter_opener', '~> 1.10'
end
