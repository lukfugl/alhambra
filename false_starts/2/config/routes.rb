require 'hydra'

Hydra.map do |hydra|
  hydra.player     '/players/:username'
  hydra.table_list '/tables'
  hydra.table      '/tables/:id'
  hydra.seat       '/tables/:table_id/seats/:slot'
end
