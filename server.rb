require 'sinatra'
require 'pg'
require 'pry'
require_relative 'movie_helpers'
require_relative 'actor_helpers'

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

#####################################
#             CONTROLLER
#####################################

# MOVIES ACTIONS
#####################################

get '/movies' do
  @movies = get_all_movies

  erb :'movies/index'
end

get '/movies/:id' do
  results = get_movie_info(params[:id])

  if !results.empty?
    @movie = {
      id: results[0]['id'],
      title: results[0]['title'],
      year: results[0]['year'],
      genre: results[0]['genre'],
      studio: results[0]['studio']
    }
  else
    @movie = {}
  end

  @cast = cast_for_movie(results)

  erb :'movies/show'
end

# ACTORS ACTIONS
#####################################

get '/actors' do
  @actors = get_all_actors

  erb :'actors/index'
end

get '/actors/:id' do
  results = get_actor_info(params[:id])

  if !results.empty?
    @actor_name = results[0]['actor']
  else
    @actor_name = ''
  end

  @movies = movies_appeared_in(results)

  erb :'actors/show'
end

