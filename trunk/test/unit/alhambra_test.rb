require 'test/unit'
require 'models/seat'
require ROOT + '/test/sqlite_transactional_tests'

class AlhambraTest < Test::Unit::TestCase
  def test_truth
    assert true
  end

  include SqliteTransactionalTests
end
