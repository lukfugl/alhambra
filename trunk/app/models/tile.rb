# building_type, walls, cost
class Tile < ActiveRecord::Base
  BUILDING_TYPES = [
    'pavilon',
    'manor',
    'mezzanine',
    'chambers',
    'garden',
    'tower'
  ]

  WALL_DIRECTIONS = [
    'east',
    'south',
    'west',
    'north'
  ]

  # accessor overrides to accept and emit a subset of WALL_DIRECTIONS rather
  # than the raw flag string (assignment can still accept the raw flag string,
  # however)
  def walls=(*walls)
    if walls.size == 1 && (walls.first =~ /^[01]{4}$/ || Array === walls.first)
      walls = walls.first
    end

    if Array === walls
      walls = WALL_DIRECTIONS.map{ |dir| walls.include?(dir) ? '1' : '0' }
      walls = walls.join('')
    end

    super(walls)
  end

  def walls
    codified_walls = super
    codified_walls.split(//).zip(WALL_DIRECTIONS).
      select{ |flag,dir| flag == '1' }.
      map{ |flag,dir| dir }
  end
end
