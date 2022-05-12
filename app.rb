require_relative './rental'
require_relative './student'
require_relative './teacher'
require_relative './classroom'
require_relative './book'

class App
  def initialize
    @books = []
    @people = []
    @rentals = []
  end

  # list added books
  def list_books(by_number: false)
    if @books.empty?
      puts 'There are no books, you can add some'
    else
      @books.each_with_index do |book, i|
        puts "#{by_number ? "#{i}) " : ''} Title: \"#{book.title}\", Author: \"#{book.author}\""
      end
    end

    list_options unless by_number
  end

  # list added people
  def list_people(by_number: false)
    if @people.empty?
      puts 'There is no record of a person, you can add a person'
    else
      @people.each_with_index do |person, i|
        number_index = (by_number ? "#{i}) " : '').to_s
        puts "#{number_index}[#{person.class.name}] Name: #{person.name}, ID: #{person.id}, Age: #{person.age}"
      end
    end
    list_options unless by_number
  end

  # create a person
  def create_person
    print 'Do you want to create a student (1) or a teacher(2) [Input the number]:'
    person_type = gets.chomp
    print 'Age:'
    age = gets.chomp
    print 'Name:'
    name = gets.chomp
    print person_type == '2' ? 'Specialization: ' : 'Has parent permission? [Y/N]:'
    parent_permission = gets.chomp
    classroom = ClassRoom.new('class-1')
    person = if person_type == '2'
               Teacher.new(parent_permission, age, name)
             else
               Student.new(classroom, age, name, parent_permission: parent_permission.upcase == 'Y')
             end
    @people << person
    puts 'Person created successfully'
    list_options
  end

  # create a book
  def create_book
    print 'Title: '
    title = gets.chomp
    print 'Author: '
    author = gets.chomp
    book = Book.new(title, author)
    @books << book
    puts 'Book created successfully'
    list_options
  end

  # create rentals
  def create_rental
    puts 'Select a book from the following list by number'
    list_books(by_number: true)
    book_index = gets.chomp
    book = @books[book_index.to_i]
    puts 'Select a person from the following list by number (not id)'
    list_people(by_number: true)
    person_i = gets.chomp
    person = @people[person_i.to_i]
    print 'Date:'
    date = gets.chomp
    rental = Rental.new(date, book, person)
    @rentals << rental
    puts 'Rental created successfully'
    list_options
  end

  # get persons rentals

  def person_rentals
    print 'ID of person:'
    person_id = gets.chomp
    rented = @rentals.select { |rental| rental.person.id == person_id.to_i }
    if rented.empty?
      puts "No rentals found for id: #{person_id}"
    else
      puts 'Rentals:'
      rented.each { |rental| puts "Date: #{rental.date} Book: \"#{rental.book.title}\" by #{rental.book.author}" }
    end
    list_options
  end

  # list options
  def list_options
    options = ['List all books', 'List all people',
               'Create a person', 'Create a book', 'Create a rental',
               'List all rentals for a given person id', 'Exit(Any key apart from 1..6 will prompt an exit)']
    puts 'Please choose an option by entering a number'
    options.each_with_index { |option, i| puts "#{i + 1} - #{option}" }
    option = gets.chomp
    option.to_i
    check_option(option)
  end

  # called to ask a user when 7 is keyed or any other key
  def exit_console
    print 'Are you sure you want to exit? You may have pressed an invalid option [Y/N]: '
    option = gets.chomp
    if option.upcase == 'Y'
      puts 'BYE! BYE!'
      exit
    else
      puts 'He who increases knowledge increases sorrow'
      list_options
    end
  end

  # read options
  def check_option(option)
    case option
    when '1'
      list_books
    when '2'
      list_people
    when '3'
      create_person
    when '4'
      create_book
    when '5'
      create_rental
    when '6'
      person_rentals
    else
      exit_console
    end
  end

  def start
    puts 'Welcome to School Library App!'
    list_options
  end
end
