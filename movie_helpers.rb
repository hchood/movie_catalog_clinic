
def get_all_movies
  query = %Q{
    SELECT movies.title, movies.year, movies.id, movies.rating, genres.name AS genre, studios.name AS studio
    FROM movies
    JOIN genres ON genres.id = movies.genre_id
    JOIN studios ON studios.id = movies.studio_id
    ORDER BY movies.title
  }

  results = db_connection do |conn|
    conn.exec(query)
  end

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

def get_movie_info(movie_id)
  query = %Q{
    SELECT movies.title, movies.year, movies.id, movies.rating, genres.name AS genre, studios.name AS studio,
    actors.id AS actor_id, actors.name AS actor, cast_members.character AS role
    FROM movies
    JOIN genres ON genres.id = movies.genre_id
    JOIN studios ON studios.id = movies.studio_id
    JOIN cast_members ON cast_members.movie_id = movies.id
    JOIN actors ON actors.id = cast_members.actor_id
    WHERE movies.id = $1;
  }

  results = db_connection do |conn|
    conn.exec_params(query, [movie_id])
  end

  results.to_a
end

def cast_for_movie(results)
  cast = []

  results.each do |result|
    cast << {
      actor_id: result['actor_id'],
      actor: result['actor'],
      role: result['role']
    }
  end

  cast
end
