require_relative 'character'

def main
  Character.create_table

  frodo = Character.find_by_name('Frodo Baggins')

  if frodo.nil?
    puts "CREATE NEW FRODO"

    frodo = Character.new(name: 'Frodo Baggins', equipped_weapon: 'sword', primary_skill: 'whining')

    frodo.save
  else
    puts "FOUND FRODO"
  end

  frodo.equipped_weapon = ''

  frodo.save

  p frodo

  gandalf = Character.find_by_name('Gandalf the White')

  if gandalf.nil?
    puts "CREATE NEW GANDALF"

    gandalf = Character.new(name: 'Gandalf the White', equipped_weapon: 'staff', primary_skill: 'badass')

    gandalf.save
  else
    puts "FOUND GANDALF"
  end

  gandalf.primary_skill = 'magic'

  gandalf.save

  p gandalf
end

main if __FILE__ == $PROGRAM_NAME
