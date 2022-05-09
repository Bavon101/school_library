class Person
  def initialize(id, age, name = 'Unknown', parent_permission: true)
    @id = id
    @name = name
    @age = age
    @parent_permission = parent_permission
  end

  attr_writer :name, :age
  attr_reader :id, :name, :age

  private

  def of_age?
    @age >= 18
  end

  def can_use_services?
    is_of_age?
  end
end