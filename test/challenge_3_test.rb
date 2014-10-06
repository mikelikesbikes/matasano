require 'minitest/autorun'
require_relative '../set-1/xor_cipher'

class Challenge1Test < Minitest::Test
  def test_xor_cipher
    cipher = Matasano::XORCipher.new
    encstr = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

    assert_equal("Cooking MC's like a pound of bacon", cipher.find_decryption(encstr))
  end
end
