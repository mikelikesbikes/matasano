require_relative 'matasano_test'

class Challenge4Test < MatasanoTest
  def test_find_decryption_in_file
    filename = File.expand_path("../challenge-4.txt", __FILE__)

    assert_equal("Now that the party is jumping\n",
                 find_decryption_in_file(filename))
  end
end
