require 'sinatra'

get '/actors' do

  erb :'actors/index'
end

get '/actors/:id' do

  erb :'actors/show'
end

get '/movies' do

  erb :'movies/index'
end

get '/movies/:id' do

  erb :'movies/show'
end
