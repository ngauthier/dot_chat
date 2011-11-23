require 'rubygems'
require 'bundler/setup'
require 'goliath'
require 'open3'

class DotChat < Goliath::API
  def on_headers(env, headers)
    env['dot-in'], env['dot-out'] = Open3.popen2("dot -Tsvg")
  end

  def on_body(env, data)
    env['dot-in'].write data
  end

  def response(env)
    env['dot-in'].close
    result = env['dot-out'].read
    env['dot-out'].close

    [200, {}, result]
  end
end
