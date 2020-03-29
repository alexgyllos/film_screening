require_relative('models/film')
require_relative('models/customer')
require_relative('models/ticket')
require_relative('models/screening')

require('pry')

Screening.delete_all()
Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

film1 = Film.new({'title' => 'Inception',
                  'fee' => 5})
film1.save()

film2 = Film.new({'title' => 'Superman',
                  'fee' => 4})
film2.save()

film3 = Film.new({'title' => 'Star Wars',
                  'fee' => 4})
film3.save()

customer1 = Customer.new({'name' => 'Bob',
                          'funds' => 15})
customer1.save()
customer2 = Customer.new({'name' => 'George',
                          'funds' => 20})
customer2.save()
customer3 = Customer.new({'name' => 'John',
                          'funds' => 22})
customer3.save()
customer4 = Customer.new({'name' => 'Mary',
                          'funds' => 13})
customer4.save()
customer5 = Customer.new({'name' => 'William',
                          'funds' => 10})
customer5.save()
customer6 = Customer.new({'name' => 'Anna',
                          'funds' => 8})
customer6.save()
customer7 = Customer.new({'name' => 'Lisa',
                          'funds' => 7})
customer7.save()
customer8 = Customer.new({'name' => 'Michael',
                          'funds' => 25})
customer8.save()

screening1 = Screening.new({'film_id' => film1.id,
                            'showtime' => '20:00',
                            'capacity' => 6})
screening1.save()

screening2 = Screening.new({'film_id' => film2.id,
                            'showtime' => '21:00',
                            'capacity' => 6})
screening2.save()

screening3 = Screening.new({'film_id' => film3.id,
                            'showtime' => '22:00',
                            'capacity' => 6})
screening3.save()

screening4 = Screening.new({'film_id' => film1.id,
                            'showtime' => '23:00',
                            'capacity' => 5})
screening4.save()

ticket1 = Ticket.new({'film_id' => film1.id,
                      'customer_id' => customer1.id,
                      'screening_id' => screening1.id})
ticket1.save()

ticket2 = Ticket.new({'film_id' => film1.id,
                      'customer_id' => customer1.id,
                      'screening_id' => screening1.id})
ticket2.save()

ticket3 = Ticket.new({'film_id' => film1.id,
                      'customer_id' => customer2.id,
                      'screening_id' => screening1.id})
ticket3.save()

ticket4 = Ticket.new({'film_id' => film2.id,
                      'customer_id' => customer3.id,
                      'screening_id' => screening2.id})
ticket4.save()

ticket5 = Ticket.new({'film_id' => film3.id,
                      'customer_id' => customer4.id,
                      'screening_id' => screening3.id})
ticket5.save()

ticket6 = Ticket.new({'film_id' => film1.id,
                      'customer_id' => customer5.id,
                      'screening_id' => screening1.id})
ticket6.save()

ticket7 = Ticket.new({'film_id' => film3.id,
                      'customer_id' => customer6.id,
                      'screening_id' => screening3.id})
ticket7.save()

ticket8 = Ticket.new({'film_id' => film1.id,
                      'customer_id' => customer7.id,
                      'screening_id' => screening1.id})
ticket8.save()

ticket9 = Ticket.new({'film_id' => film2.id,
                      'customer_id' => customer8.id,
                      'screening_id' => screening2.id})
ticket9.save()

ticket10 = Ticket.new({'film_id' => film2.id,
                       'customer_id' => customer8.id,
                       'screening_id' => screening2.id})
ticket10.save()

customer1.update_funds()
customer2.update_funds()
customer3.update_funds()
customer4.update_funds()
customer5.update_funds()
customer6.update_funds()
customer7.update_funds()
customer8.update_funds()

screening1.update_tickets()
screening2.update_tickets()
screening3.update_tickets()
screening4.update_tickets()

binding.pry
nil
