require_relative('../db/sql_runner')
require_relative('./customer')

class Ticket
  attr_reader :id
  attr_accessor :film_id, :customer_id, :screening_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id']
    @customer_id = options['customer_id']
    @screening_id = options['screening_id']
  end

  def save()
      sql = "INSERT INTO tickets (film_id, customer_id, screening_id)
             VALUES ($1, $2, $3)
             RETURNING id"
      values = [@film_id, @customer_id, @screening_id]
      ticket = SqlRunner.run(sql, values).first()
      @id = ticket['id'].to_i
  end

  def film()
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    film_hash = SqlRunner.run(sql, values).first()
    return Film.new(film_hash)
  end

  def customer()
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    customer_hash = SqlRunner.run(sql, values).first()
    return Customer.new(customer_hash)
  end

  def screening()
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [@screening_id]
    screening =  SqlRunner.run(sql, values).first()
    return Screening.new(screening)
  end

  def film_fee()
    sql = "SELECT films.* FROM films
           INNER JOIN tickets
           ON films.id = tickets.film_id
           WHERE tickets.customer_id = $1"
    values = [@customer_id]
    film_fee = SqlRunner.run(sql, values).first()
    fee = Film.new(film_fee).fee.to_i
    return fee
  end

  def find_funds()
    sql = "SELECT customers.* FROM customers WHERE id = $1"
    values = [@customer_id]
    customers_funds = SqlRunner.run(sql, values).first()
    funds = Customer.new(customers_funds).funds.to_i
    return funds
  end

  def number_of_tickets_sold()
    sql = "SELECT screenings.* FROM screenings WHERE id = $1"
    values = [@screening_id]
    result = SqlRunner.run(sql, values).first
    return tickets = Screening.new(result).number_of_tickets.to_i
  end

  def screening_capacity()
    sql = "SELECT screenings.* FROM screenings WHERE id = $1"
    values = [@screening_id]
    result = SqlRunner.run(sql, values).first
    return capacity = Screening.new(result).capacity.to_i
  end

  def Ticket.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql, [])
  end

  def Ticket.all()
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    result = tickets.map {|ticket| Ticket.new(ticket)}
    return result
  end

  def Ticket.create_ticket(film_id, customer_id, screening_id)
    sql = "INSERT INTO tickets (film_id, customer_id, screening_id)
           VALUES ($1, $2, $3)
           RETURNING id"
    values = [film_id, customer_id, screening_id]
    ticket = SqlRunner.run(sql, values).first()
    @id = ticket['id'].to_i
  end

  def Ticket.sell(screening, film, customer)
    return if screening.over_capacity?()
    Ticket.create_ticket(film.id, customer.id, screening.id)
    screening.update_tickets()
    customer.new_ticket_funds_update(film)
  end
end
