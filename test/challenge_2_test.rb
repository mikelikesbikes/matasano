require_relative 'test_helper'

class Challenge2Test < Minitest::Test
  def test_fixed_xor
    d1 = hex_to_bytes("1c0111001f010100061a024b53535009181c")
    d2 = hex_to_bytes("686974207468652062756c6c277320657965")

    assert_equal("746865206b696420646f6e277420706c6179",
                 bytes_to_hex(fixed_xor(d1, d2)))
  end
end
