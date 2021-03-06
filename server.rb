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

  if params[:page] && params[:page] != '1'
    offset = (params[:page].to_i - 1) * 20 - 1
  else
    offset = 0
  end

  if params[:query]
    search_term = "WHERE movies.title ILIKE '%#{params[:query]}%' or movies.synopsis ILIKE '%#{params[:query]}%'"
  end

  query = %Q{
    SELECT movies.title, movies.year, movies.id, movies.rating, genres.name AS genre, studios.name AS studio
    FROM movies
    JOIN genres ON genres.id = movies.genre_id
    JOIN studios ON studios.id = movies.studio_id
    #{search_term}
    ORDER BY movies.#{order}
    OFFSET #{offset}
    LIMIT 20
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


