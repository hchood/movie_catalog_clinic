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

def get_all_movies(params)
  order = params[:order] || 'title'

  query = %Q{
    SELECT movies.title, movies.year, movies.id, movies.rating, genres.name AS genre, studios.name AS studio
    FROM movies
    JOIN genres ON genres.id = movies.genre_id
    JOIN studios ON studios.id = movies.studio_id
    ORDER BY movies.#{order}
  }

  results = db_connection do |conn|
    conn.exec(query)
  end

  create_movies_array(results)
end

def create_movies_array(results)
  movies = []

  results.each do |movie|
    movie = {
      id: movie['id'].to_i,
      title: movie['title'],
      year: movie['year'].to_i,
      rating: movie['rating'].to_i,
      genre: movie['genre'],
      studio: movie['studio']
    }
    movies << movie
  end

  movies
end

#####################################
#             CONTROLLER
#####################################

get '/movies' do
  @movies = get_all_movies(params)

  erb :'movies/index'
end


