require "rubygems"
require "sinatra"
require "json"
require "data_mapper"
require 'dm-migrations'
require 'will_paginate'
require 'will_paginate/collection'
require 'will_paginate/view_helpers'
require 'haml'
require 'active_attr'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:unicodes.db")
#DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://localhost/unicodes')

class Pagination
  include ActiveAttr::Model
  attribute :next_page
  attribute :previous_page
  attribute :offset
  attribute :current_page
  attribute :total_pages
  attribute :total_entries
end

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

DataMapper.finalize
DataMapper.auto_upgrade!

get '/' do
  "ok - just a test ;-)"
end


get '/characters' do
  @term = params[:term] || ''
  @characters = Character.paginated_search(params, @term)
  haml :index, :format => :html5
end


get '/characters.json' do
  @term = params[:term] || ''
  @characters = Character.paginated_search(params, @term)
  pagination = Pagination.new(:next_page => url_for_page(@characters.next_page, @term), 
                              :previous_page => url_for_page(@characters.previous_page, @term),
                              :current_page =>  url_for_page(@characters.current_page, @term),
                              :offset => @characters.offset,
                              :total_entries =>  @characters.total_entries,
                              :total_pages => @characters.total_pages)
  content_type :json
  {:characters => @characters, :pagination => pagination}.to_json

end

get '/webapp' do
  haml :webapp, :format => :html5
end

def url_for_page(page, term)
  if page.nil?
    return ''
  else
    return "http://#{request.host_with_port}#{request.path_info}?page=#{page}&term=#{term}"
  end
end