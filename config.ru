require 'bundler'

Bundler.require

require 'pry'
require 'net/http'

%w(data_cache with_cache upstream).each do |f|
  require_relative "src/#{f}"
end

class App < Sinatra::Base
  include WithCache

  before { content_type :json }

  set :show_exceptions, :after_handler
  error 500 { {error: env['sinatra.error'].message}.to_json }
  error 404 { {error: 'Not implement yet!!' }.to_json }


  get '/reference/:item/for/:parent_id' do |item, parent_id|
    slug = "#{parent_id}-#{item}"
    with_cache(slug) do
      Upstream.new(item, parent_id).get_data
    end
  end
end

map '/api' do
  run App
end