# poor man's sqlite "transactional" tests; copy original state of db to a
# tmp file on setup, then move it back and reestablish the connection on
# teardown
module SqliteTransactionalTests
  def self.included(other)
    original_setup = other.instance_method(:setup)
    original_teardown = other.instance_method(:teardown)

    other.class_eval do
      define_method :setup do
        File.send(:cp, ROOT + "/db/models.db", ROOT + "/db/models.db.tmp")
        original_setup.bind(self).call
      end

      define_method :teardown do
        original_teardown.bind(self).call
        File.send(:mv, ROOT + "/db/models.db.tmp", ROOT + "/db/models.db")
        connection = ActiveRecord::Base.remove_connection
        ActiveRecord::Base.send(:clear_all_cached_connections!)
        ActiveRecord::Base.establish_connection(connection)
      end
    end
  end
end
