require 'em_test_helper'

require 'thread'

class TestDefer < Test::Unit::TestCase

  def test_defers
    n = 0
    n_times = 20
    mutex = Mutex.new
    EM.run {
      n_times.times {
        work_proc = proc { mutex.synchronize { n += 1 } }
        callback = proc { EM.stop if mutex.synchronize { n == n_times } }
        EM.defer work_proc, callback
      }
    }
    assert_equal( n, n_times )
  end

end
