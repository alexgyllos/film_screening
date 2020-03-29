require_relative('../db/sql_runner')

class Film

  attr_reader :id
  attr_accessor :title, :fee

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @fee = options['fee']
  end

  def save()
    sql = "INSERT INTO films (title, fee)
           VALUES ($1, $2)
           RETURNING id"
    values = [@title, @fee]
    film = SqlRunner.run(sql, values).first()
    @id = film['id'].to_i
  end

  def customers()
    sql = "SELECT customers.* FROM customers
           INNER JOIN tickets
           ON customers.id = tickets.customer_id
           WHERE tickets.film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map {|customer| Customer.new(customer)}
  end

  def amount_of_customers()
    return customers().length
  end

  def screenings()
    sql = "SELECT screenings.* FROM screenings WHERE film_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map {|screening| Screening.new(screening)}
  end

  def Film.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql, [])
  end

  def Film.all()
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    result = films.map {|film| Film.new(film)}
    return result
  end

  def Film.all_alphabetically_by_title()
    sql = "SELECT * FROM films ORDER BY title"
    films = SqlRunner.run(sql)
    return films.map {|film| Film.new(film)}
  end
end
