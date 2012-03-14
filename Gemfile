source :gemcutter

gem 'foreman'
gem 'sinatra'
gem 'thin'
gem 'will_paginate'
gem 'data_mapper'
gem 'dm-sqlite-adapter'
gem 'haml'
gem 'json'
gem 'heroku'


group :production do
    gem "pg"
    gem "dm-postgres-adapter"
end

group :development, :test do
    gem "sqlite3"
    #gem 'sqlite3-ruby', :require => 'sqlite3'
    gem "dm-sqlite-adapter"
end