require "rubygems"
require "sinatra"
require "json"
require "data_mapper"
require 'will_paginate'
require 'will_paginate/collection'
require 'will_paginate/view_helpers'
require 'haml'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/unicodes.db")


class Character
  include DataMapper::Resource

  property :id, Serial
  property :code, String
  property :hex, String
  property :ref, String
  property :description, String
  
  def self.paginated_search(params, term)
    
    per_page = params[:per_page] || 20
    page = params[:page] || 1
    
    page = page.to_i
    page -= 1
    
    per_page = per_page.to_i

    offset = per_page * page

    characters = Character.all

    # apply search term is there is one
    characters = characters.all({:description.like => "%#{term}%"}) unless term.empty?

    # get the current set of characters to display
    characters_on_this_page = characters.all(:limit => per_page, :offset => offset)

    return WillPaginate::Collection.create(page + 1, per_page, characters.count) {|p| p.replace characters_on_this_page }
   
  end
  
end

#helpers Pagination::Helpers

get '/characters' do
  @term = params[:term] || ''
  @characters = Character.paginated_search(params, @term)
  
  # render /views/index.haml
  haml :index, :format => :html5
  
end


get '/characters.json' do
  @term = params[:term] || ''
  @characters = Character.paginated_search(params, @term)
  content_type :json
  @characters.to_json

end