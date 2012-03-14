source :gemcutter

gem 'rake'
gem 'foreman'
gem 'sinatra'
gem 'thin'
gem 'will_paginate'
gem 'data_mapper'
gem 'haml'
gem 'json'
gem 'dm-mysql-adapter'
gem 'dm-sqlite-adapter'
gem 'brightbox'
gem 'sqlite3-ruby', :require => 'sqlite3'

group :production do
    gem "pg"
    gem "dm-postgres-adapter"
end

group :development, :test do
    #gem "sqlite3"
    gem 'sqlite3-ruby', :require => 'sqlite3'
    #gem "dm-sqlite-adapter"
    gem 'dm-migrations'
end