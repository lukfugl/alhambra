require 'atom/entry'

class Game < ActiveRecord::Base
  def uuid
    self.id.to_s
  end

  def to_atom_entry
    entry = Atom::Entry.new
    entry.id = self.uuid
    entry.title = self.name
    entry.summary = self.summary
    entry.published = self.created_at
    entry.updated = self.updated_at
    return entry
  end
end
