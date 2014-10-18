require 'test_helper'

class Challenge4Test < Minitest::Test
  def test_find_decryption_in_file
    strings = File.readlines(File.expand_path("../challenge-4.txt", __FILE__))
                  .map { |l| hex_to_bytes(l.chomp) }

    assert_equal("Now that the party is jumping\n",
                 find_best_decryption(strings))
  end
end
