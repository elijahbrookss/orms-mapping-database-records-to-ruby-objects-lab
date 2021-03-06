class Student
  attr_accessor :id, :name, :grade


  def self.new_from_db(row)
    new_student = self.new

    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]

    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    all = DB[:conn].execute("SELECT * FROM students")
    all.collect{ |row| self.new_from_db(row) }


  end

  def self.find_by_name(name)
    
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.name = ?
    SQL

    selection = DB[:conn].execute(sql, name).flatten
    new_student = self.new_from_db(selection)
    
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 9
    SQL

   selection = DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
    SQL

    selection = DB[:conn].execute(sql)
    selection.collect{ |row| self.new_from_db(row) }
  end

  def self.first_X_students_in_grade_10(x)

    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?
    SQL

    selection = DB[:conn].execute(sql, x)
    selection.collect{ |row| self.new_from_db(row) }
  end

  
  def self.first_student_in_grade_10

    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT 1
    SQL

    selection = DB[:conn].execute(sql)[0]
    self.new_from_db(selection)
  end


  def self.all_students_in_grade_X(x)
    sql = <<-SQL

      SELECT * FROM students
      WHERE grade = ?

    SQL

    selection = DB[:conn].execute(sql, x)
    selection.collect{ |row| self.new_from_db(row) }


  end


end
