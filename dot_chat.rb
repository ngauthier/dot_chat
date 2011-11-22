require 'rubygems'
require 'bundler/setup'
require 'goliath'

class DotChat < Goliath::API
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
