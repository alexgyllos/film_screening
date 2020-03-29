require_relative("../db/sql_runner")
require_relative("./ticket")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  def save()
    sql = "INSERT INTO customers (name, funds)
           VALUES ($1, $2)
           RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first()
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.* FROM films
         INNER JOIN tickets
         ON films.id = tickets.film_id
         WHERE tickets.customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map {|film| Film.new(film)}
  end

  def amount_of_tickets()
    sql = "SELECT tickets.* FROM tickets WHERE tickets.customer_id = $1"
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    return tickets.map {|ticket| Ticket.new(ticket)}.count
  end

  def remaining_funds()
    @funds - films().map {|film| film.fee.to_i}.sum
  end

  def update_funds()
    @funds = remaining_funds()
    update()
  end

  def new_ticket_funds_update(film)
    result = @funds - film.fee
    @funds = result
    update()
  end

  def Customer.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql, [])
  end

  def Customer.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    result = customers.map {|customer| Customer.new(customer)}
    return result
  end
end
