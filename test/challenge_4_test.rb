require 'minitest/autorun'
require_relative '../set-1/xor_cipher'

class Challenge1Test < Minitest::Test
  def test_detect_encryption
    cipher = Matasano::XORCipher.new
    assert_equal("Now that the party is jumping\n",
                 cipher.find_decryption_in_file(File.expand_path("./challenge-4.txt", File.dirname(__FILE__))))
  end
end
