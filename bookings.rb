require 'active_record'

require 'minitest/autorun'
require 'minitest/spec'
require 'pry'
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: "#{File.dirname(__FILE__)}/database.sqlite3" #:memory:"

#
# Define your migrations here, they should take the form of:
#
# ActiveRecord::Migration.create_table :fruits do |t|
ActiveRecord::Migration.create_table :users do |t|
  t.string :name
end

ActiveRecord::Migration.create_table :hotels do |t|
  t.string :name
end

ActiveRecord::Migration.create_table :rooms do |t|
  t.float :rate
  t.belongs_to :hotel
end

ActiveRecord::Migration.create_table :bookings do |t|
  t.boolean :paid, default: false
  t.belongs_to :user
  t.belongs_to :room
end
# #   t.string :name
# #   t.belongs_to :bowl
# # end
# #
# # Repeat the above template for each table you need to create


# #
# # end migrations
# #
# #
# # the following line executes the migrations, don't delete it
# ActiveRecord::Migrator.up "db/migrate"


#
# Define your AR classes below:
# for example:
#
# class Fruit < ActiveRecord::Base
#   belongs_to :bowl
# end
class User < ActiveRecord::Base
  has_many :bookings
  has_many :rooms, through: :bookings
end

class Hotel < ActiveRecord::Base
  has_many :rooms
  has_many :bookings, through: :rooms
  has_many :booked_guests, through: :bookings, source: :user
end

class Room < ActiveRecord::Base
  has_many :bookings
  belongs_to :hotel
end

class Booking < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  belongs_to :guest, :class_name => "User", foreign_key: :user_id
end



#
# You can define multiple classes, one after another





#
# end migrations


#
# Seeds - Below write the necessary code to seed the database
# so the tests pass.
#
# 1) Create three users with the names: "Francis Slim", "Julie Blook" and "Mike Rasta"
User.create(name:"Francis Slim")
User.create(name:"Julie Blook")
User.create(name:"Mike Rasta")

# 2) Create a hotel named "Westin" with 5 rooms at a rate of $300
westin = Hotel.create(name: "Westin")
5.times do
  westin.rooms.build(rate: 300.00)
end
westin.save


# 3) Create a hotel named "Ritz" with 3 rooms at a rate of $500
ritz = Hotel.create(name: "Ritz")
3.times do
  ritz.rooms.build(rate: 500.00)
end
ritz.save

# 4) Create a booking for Julie at the Ritz
Booking.create(user_id: 2, room_id: 6)

# 5) Create a booking for Francis at the Westin and another
#    booking for him at the Ritz
Booking.create(user_id: 1, room_id: 1)
Booking.create(user_id: 1, room_id: 7)

# 6) Create two bookings for Mike at the Westin that are both
#    marked as paid
Booking.create(user_id: 3, room_id: 2, paid: true)
Booking.create(user_id: 3, room_id: 3, paid: true)

#
# end seeds



#
# Tests - Do not modify anything below this line. Run the tests by
# runing this file on the command line (ruby -rminitest/pride bookings.rb)
#
#
describe "AR Tests" do
  before do
    @francis = User.find_by(name: "Francis Slim")
    @julie = User.find_by(name: "Julie Blook")
    @mike = User.find_by(name: "Mike Rasta")

    @ritz = Hotel.find_by(name: "Ritz")
    @westin = Hotel.find_by(name: "Westin")
  end

  describe "Base Records" do
    describe User do
      it "three users with correct names should exist in the database" do
        User.order(:name).map(&:name).must_equal ["Francis Slim", "Julie Blook", "Mike Rasta"];
      end
    end

    describe Hotel do
      it "two hotels Westin and Ritz should exist in the database" do
        Hotel.order(:name).map(&:name).must_equal ["Ritz", "Westin"]
      end

      it "the Westin hotel should have 5 rooms" do
        @westin.rooms.count.must_equal 5
      end

      it "the Westin hotel's room's should all cost $300" do
        @westin.rooms.map(&:rate).uniq.must_equal [300]
      end

      it "the Ritz hotel should have 3 rooms" do
        @ritz.rooms.count.must_equal 3
      end

      it "the Ritz hotel's room's should all cost $500" do
        Hotel.find_by(name: "Ritz").rooms.map(&:rate).uniq.must_equal [500]
      end
    end
  end

  describe "Bookings" do
    it "Francis should have 2 bookings" do
      @francis.bookings.count.must_equal 2
    end

    it "Francis should have 1 booking at the Ritz" do
      @ritz.booked_guests.must_include @francis
    end

    it "Francis should have 1 booking at the Westin" do
      @westin.booked_guests.must_include @francis
    end

    it "Julie should have 1 booking at the Ritz" do
      @ritz.booked_guests.must_include @julie
    end

    it "Mike should have 2 bookings at the Westin" do
      @westin.bookings.where(guest: @mike).count.must_equal 2
    end

    it "Mike's bookings should be marked as paid" do
      @mike.bookings.all?(&:paid).must_equal true
    end

    it "the Westin should have 3 bookings" do
      @westin.bookings.count.must_equal 3
    end

    it "the Ritz should have 2 bookings" do
      @ritz.bookings.count.must_equal 2
    end
  end
end
