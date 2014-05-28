require 'sinatra'
require 'pg'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: 'movies')

    yield(connection)

  ensure
    connection.close
  end
end

def sort_by_name(actors)
  actors.sort_by { |actor| actor['name'] }
end

get '/actors' do
  query = 'SELECT * FROM actors'

  results = db_connection do |conn|
    conn.exec(query)
  end

  @actors = sort_by_name(results.to_a)

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
