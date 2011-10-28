require 'rubygems'
require 'bundler/setup'
require 'goliath'

class DotConverter < Goliath::API
  use Goliath::Rack::Params 
  use Goliath::Rack::Validation::RequiredParam, {:key => 'dot'}

  def response(env)
    dot = env.params['dot']
    result = nil

    IO.popen("dot -Tsvg", "r+") do |io|
      io.write dot
      io.close_write
      result = io.read
    end

    [200, {}, result]
  end
end

$index = File.read('index.html')

class FileServer < Goliath::API
  use Goliath::Rack::Params 
  def response(env)
    params[:file] ||= 'index.html'
    data = nil
    if File.exist?(params[:file])
      [200, {"Content-Type" => "text/html"}, File.read(params[:file])]
    else
      [404, {"Content-Type" => "text/html"}, "File not found"]
    end
  end
end

class DotChat < Goliath::API
  map "/dot", DotConverter
  map '/:file', FileServer
  map '/', FileServer
end
