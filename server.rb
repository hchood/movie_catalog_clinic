require 'sinatra'
require 'pg'
require 'pry'

#####################################
#             METHODS
#####################################

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

def get_all_actors
  query = 'SELECT * FROM actors'

  results = db_connection do |conn|
    conn.exec(query)
  end

  results.to_a
end

#####################################
#             ROUTES
#####################################

get '/actors' do
  results = get_all_actors

  @actors = sort_by_name(results)

  erb :'actors/index'
end

get '/actors/:id' do
  actor_id = params[:id]

  query = %Q{
    SELECT actors.name AS actor, movies.title AS movie_title, movies.id AS movie_id
    FROM actors
    JOIN cast_members ON actors.id = cast_members.actor_id
    JOIN movies ON movies.id = cast_members.movie_id
    WHERE actors.id = $1;
  }

  results = db_connection do |conn|
    results = conn.exec_params(query, [actor_id])
    results.to_a
  end

  @actor_name = results[0]['actor']

  @movies = []

  results.each do |result|
    @movies << { title: result['movie_title'], id: result['movie_id'] }
  end

  erb :'actors/show'
end

get '/movies' do

  erb :'movies/index'
end

get '/movies/:id' do

  erb :'movies/show'
end
