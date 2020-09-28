class Dog 
  
  attr_accessor :name, :breed 
  attr_reader :id
  
  def initialize(name:, breed:, id: nil )
    @name = name 
    @breed = breed
    @id = id
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(id INTEGER PRIMARY KEY, name TEXT, breed TEXT);
      SQL
      DB[:conn].execute(sql)
    end
  def self.drop_table
    sql = <<-SQL
      DROP TABLE dogs;
      SQL
      DB[:conn].execute(sql)
    end
    
    
  def self.create(hash_attr)
    name = hash_attr[:name]
    breed = hash_attr[:breed]
    new_dog = self.new(name: name, breed: breed)
    new_dog.save
  end
  
  
  def self.new_from_db(array)
    array = array[0] if array[1] == nil
    id = array[0]
    name = array[1]
    breed = array[2]
    
    self.new(id: id, name: name, breed: breed)
  end
  
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM dogs 
      WHERE name = ?
      SQL
      DB[:conn].execute(sql, name)
    end
    
  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?,?)
      SQL
      DB[:conn].execute(sql, @name, @breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      self
   end
  
  def self.find_by_id(id)
    sql = <<-SQL
      SELECT *
      FROM dogs 
      WHERE id = ?
      SQL
      array = DB[:conn].execute(sql, id)
      self.new_from_db(array)
  end
  
  def self.find_by_name_and_breed(name,breed)
    sql = <<-SQL
      SELECT *
      FROM dogs 
      WHERE name = ? AND breed = ?
      SQL
      puts DB[:conn].execute(sql, name, breed)
      DB[:conn].execute(sql, name, breed)
    end
  
  
  def self.find_or_create_by(hash)
    puts find_by_name_and_breed(hash[:name], hash[:breed]).class
    
    if find_by_name_and_breed(hash[:name], hash[:breed])[1] == nil     #new dog
    puts "hahahahahahahah #{hash}"
      create(hash)
      
      
    # elsif find_by_name(hash[:name])[2] == hash[:breed]
    #   find_by_name(hash[:name])
    
    
    else 
      
      new_from_db(find_by_name_and_breed(hash[:name],hash[:breed]))
      
    end
  end
  
  
  
  
end     #ends class
