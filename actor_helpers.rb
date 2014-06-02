
def get_all_actors
  query = %Q{
    SELECT * FROM actors
    ORDER BY name
  }

  results = db_connection do |conn|
    conn.exec(query)
  end

  results.to_a
end

def get_actor_info(actor_id)
  query = %Q{
    SELECT actors.name AS actor, movies.title AS movie_title, movies.id AS movie_id, cast_members.character AS role
    FROM actors
    JOIN cast_members ON actors.id = cast_members.actor_id
    JOIN movies ON movies.id = cast_members.movie_id
    WHERE actors.id = $1;
  }

  results = db_connection do |conn|
    conn.exec_params(query, [actor_id])
  end

  results.to_a
end

def movies_appeared_in(actor_results)
  movies = []

  actor_results.each do |result|
    movies << {
      title: result['movie_title'],
      id: result['movie_id'],
      role: result['role'],
      rating: result['rating'].to_i
    }
  end

  movies
end
