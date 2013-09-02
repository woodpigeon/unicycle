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

# Sqlite data source using the DataMapper ORM
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3:unicodes.db") 


# A model representing a unicode character, maps to a characters table in the database
class Character
  include DataMapper::Resource
  
  property :id, Serial
  property :code, String
  property :hex, String
  property :ref, String
  property :description, String
  
  # Helper method to search and return an array of characters paginated usin the will_paginate gem
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


# This root url delivers a json-driven page with no server-side view formatting at all
get '/' do
  haml :webapp, :format => :html5
end


# This url delivers a server-side page using haml
get '/characters' do
  @term = params[:term] || ''
  @characters = Character.paginated_search(params, @term)
  haml :index, :format => :html5
end

# This url is a web service serving up characters as paginated json
# This is the format of the json returned
# {
#     "characters": 
#       [
#         {
#           "code": " ",
#           "id": 1,
#           "hex": "U+0020",
#           "description": "SPACE",
#           "ref": "&amp;#32;"
#           },
#           {...}
#       ],
#     "pagination": {
#         "total_entries": 11293,
#         "current_page_number": {
#             "name": "page",
#             "_dc_obj": 1
#         },
#         "total_pages": 565,
#         "previous_page": "",
#         "next_page": "http://unicycle.woodpigeon.com/characters.json?page=2&term=",
#         "offset": 0,
#         "current_page": "http://unicycle.woodpigeon.com/characters.json?page=1&term="
#     }
# }
get '/characters.json' do
  
  content_type :json
  
  @term = params[:term] || ''
  
  @characters = Character.paginated_search(params, @term)

  pagination = { :next_page => url_for_page(@characters.next_page, @term), 
                              :previous_page => url_for_page(@characters.previous_page, @term),
                              :current_page =>  url_for_page(@characters.current_page, @term),
                              :current_page_number => @characters.current_page,
                              :offset => @characters.offset,
                              :total_entries =>  @characters.total_entries,
                              :total_pages => @characters.total_pages}
  
  {:characters => @characters, :pagination => pagination}.to_json

end

# Helper to format urls returned in the pagination json
def url_for_page(page, term)
  if page.nil?
    return ''
  else
    return "http://#{request.host_with_port}#{request.path_info}?page=#{page}&term=#{term}"
  end
end
