require 'pg'

class Character
  attr_accessor :name, :equipped_weapon, :primary_skill

  def initialize(options)
    @id = options.key?(:id) ? options[:id].to_i : (options.key?('id') ? options['id'].to_i : nil)
    @name = options[:name] || options['name']
    @equipped_weapon = options[:equipped_weapon] || options['equipped_weapon']
    @primary_skill = options[:primary_skill] || options['primary_skill']
  end

  def save
    conn = PG.connect(dbname: 'rpg_character')

    if @id.nil?
      result = conn.exec_params(
        'INSERT INTO characters (name, equipped_weapon, primary_skill) VALUES ($1, $2, $3) RETURNING id',
        [@name, @equipped_weapon, @primary_skill])
      @id = result[0]['id'].to_i
    else
      result = conn.exec_params(
        'UPDATE characters SET name = $1, equipped_weapon = $2, primary_skill = $3 WHERE id = $4',
        [@name, @equipped_weapon, @primary_skill, @id])
    end

    conn.close
  end

  def self.create_table
    conn = PG.connect(dbname: 'rpg_character')

    conn.exec('SET client_min_messages TO warning;')

    conn.exec('CREATE TABLE IF NOT EXISTS characters (' \
      'id serial primary key not null,' \
      'name varchar unique,' \
      'equipped_weapon varchar,' \
      'primary_skill varchar)')

    conn.close
  end

  def self.find_by_name(name)
    conn = PG.connect(dbname: 'rpg_character')

    result = conn.exec_params('SELECT * FROM characters WHERE name = $1', [name])

    conn.close

    Character.new(result[0]) unless result.num_tuples.zero?
  end
end
