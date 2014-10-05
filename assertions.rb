module Assertions
  def assert(condition)
    raise "assertion failed" unless condition
  end
end

include Assertions
