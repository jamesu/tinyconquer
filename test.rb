require 'rubygems'
require 'sinatra'

set :public_folder, File.dirname(__FILE__) + '/Export/html5/bin'

get '/' do
  content_type 'text/html'
  File.open('Export/html5/bin/index.html'){|o|o.read}
end

