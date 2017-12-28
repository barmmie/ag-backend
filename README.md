# Pre-requisites
* A Rails development environment.
* Postgres

# Installation and Steps to take
* Clone the repo
* `bundle install && rake db:create && rake db:migrate` to setup database
* Add in functionalities to make tests pass
* Share a link to your app's repo

# Schema info
Simple Rails app for storing events, and event tickets.
The Event model has three logic columns - the title, artist name and a JSON field storing overrides/custom configuration.


The Ticket model has five columns - the price per ticket, the quantity of tickets available, the source of the tickets, a foreign reference to the event record it belongs to, and a value for splits.


Splits, or split vectors are a way to specify what quantities of a ticket can be purchased by a single order. So, for example, say a ticket record is priced at 40 dollars per ticket, with a quantity of 10, and a splits-value of [2, 4]. This means for any order, or purchase, only combinations of 2 and 4 can be purchased. So, only an order for 2 tickets, 4 tickets, 6 tickets, 8 tickets or 10 tickets can be fulfilled. That is, either multiples of 2, 4, or (2 + 4). So an order for 1 ticket, 3 tickets, 5 tickets, 7 tickets or 9 tickets can't be fulfilled. And an order above the quantity - 11 tickets for example can't be fulfilled using just this ticket. It has to be combined with different ticket record(s).

# Starting the Test
Run `bundle exec rspec` to see a list of currently failing tests.
Then, add in missing methods, or functionality in order to make the tests pass. Everything else could be modified except the tests. Those stay frozen. Your goal should be getting the tests to pass by including the missing functionalities.

Try to reduce redundancy as much as possible.