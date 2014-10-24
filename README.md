# Advanced ActiveRecord Drill

## Learning Goals

This challenge will give you the chance to practice advanced AR techniques including:

* modeling a many-to-many relationship using a join model
* using more meaningful (non-conventional) names for associations.
* seeding records in a complex schema


## Helpful Materials

If AR isn't your strong suit yet, the following material will prove helpful. You might want to read through these links before starting:

* [Choosing Between has_many through and has_and_belongs_to_many](http://guides.rubyonrails.org/association_basics.html#choosing-between-has-many-through-and-has-and-belongs-to-many)
* [belongs_to](http://apidock.com/rails/ActiveRecord/Associations/ClassMethods/belongs_to)
* [has_many](http://apidock.com/rails/ActiveRecord/Associations/ClassMethods/has_many)

For this challenge it's critical that you become familiar with the association options `:class_name` and `:source`. Refer to the API doc links above (under the section 'Options') for details on these options.


## Hotel Bookings
You'll be modeling a simple hotel booking application. This challenge is all about ActiveRecord, it doesn't include an interface.

Your challenge is to create migrations, AR classes and seed data for the following models:

1. User
2. Hotel
3. Room
4. Booking

## Requirements
* A hotel will have many rooms
* The room model should include a `rate` attribute
* A user can book a room by way of a booking record
* You must define your assocations so the following code would work:

```ruby
  @hotel.bookings # returns all the bookings for @hotel
  @hotel.booked_guests # returns an array of Users that have bookings for @hotel
  @booking.guest # returns a User
  @user.booked_rooms # returns an array of rooms this user has booked
```

Run the tests to see the full set of requirements.

## Logistics
This challenge uses AR in a way you're probably not used to. It uses an in-memory SQLite database. So you won't ever need to run `rake db:migrate` or `rake db:drop`. The entire database is created then dropped each time you run the Ruby file `bookings.rb`.

Refer to the comments in `bookings.rb` for notes of how & where to write your migrations, class definitions and seeds code.

Why do it this way? By doing all the work in a single file (and using an in-memory database) you'll get faster feedback on your work. Those tedious `rake` tasks take time and only serve as a distraction.

## Running the Challenge
After you've run `bundle install`, run the challenge like so
```
ruby -rminitest/pride bookings.rb
```

There's a lot of failing tests, but don't be overwhelmed. Work through them one at a time.
