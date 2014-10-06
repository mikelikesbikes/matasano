require 'minitest/autorun'
require_relative '../set-1/matasano'

class Challenge1Test < Minitest::Test
  def test_hex_to_base64
    str = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
    expected = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

    assert_equal(expected, Matasano::Utils.hex_to_base64(str))
  end
end
