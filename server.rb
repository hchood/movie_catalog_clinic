require 'sinatra'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: 'movies')

    yield(connection)

  ensure
    connection.close
  end
end

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
