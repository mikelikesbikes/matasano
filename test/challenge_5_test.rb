require 'minitest/autorun'
require_relative '../set-1/xor_cipher'

class Challenge1Test < Minitest::Test
  def test_repeating_cipher_key
    cipher = Matasano::XORCipher.new
    str = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
    expected = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"

    assert_equal(expected,
                 Matasano::Utils.bytes_to_hex(
                   Matasano::XORCipher.new.encrypt(
                     Matasano::Utils.bytes_to_hex(str), "ICE")))
  end
end
