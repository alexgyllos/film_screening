require_relative('../db/sql_runner')
require_relative('./ticket')

require('pry')

class Screening

  attr_reader :id
  attr_accessor :ticket_id, :showtime, :capacity, :number_of_tickets
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id']
    @showtime = options['showtime']
    @capacity = options['capacity']
    @number_of_tickets = options['number_of_tickets']
  end

  def save()
    sql = "INSERT INTO screenings (film_id, showtime, capacity, number_of_tickets)
           VALUES ($1, $2, $3, $4)
           RETURNING id"
    values = [@film_id, @showtime, @capacity, @number_of_tickets]
    screening = SqlRunner.run(sql, values).first()
    @id = screening['id'].to_i
  end

  def update()
    sql = "UPDATE screenings SET (film_id, showtime, capacity, number_of_tickets) = ($1, $2, $3, $4) WHERE id = $5"
    values = [@film_id, @showtime, @capacity, @number_of_tickets, @id]
    SqlRunner.run(sql, values)
  end

  def tickets()
    sql = "SELECT tickets.* FROM tickets
           INNER JOIN screenings
           ON tickets.screening_id = screenings.id
           WHERE screenings.id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.map {|ticket| Ticket.new(ticket)}
  end

  def no_of_tickets()
    tickets().count
  end

  def update_tickets()
    result = no_of_tickets()
    @number_of_tickets = result
    update()
  end

  def over_capacity?()
    @capacity <= no_of_tickets()
  end

  def Screening.popular()
    Screening.all.max_by {|screening| screening.no_of_tickets}
  end

  def Screening.all()
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql)
    result = screenings.map {|screening| Screening.new(screening)}
    return result
  end

  def Screening.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql, [])
  end
end
