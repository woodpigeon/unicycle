source 'https://rubygems.org'

ruby '2.2.3'

gem 'active_attr'
gem 'rake'
gem 'foreman'
gem 'sinatra'
gem 'thin'
gem 'will_paginate'
gem 'data_mapper'
gem 'haml'
gem 'json'
gem 'dm-sqlite-adapter'

group :production do
    gem "pg"
    gem "dm-postgres-adapter"
end

group :development, :test do
    gem 'sqlite3-ruby', :require => 'sqlite3'
    gem 'dm-migrations'
    gem 'sqlite3'
end
