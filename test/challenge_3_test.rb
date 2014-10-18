require_relative 'matasano_test'

class Challenge3Test < MatasanoTest
  def test_find_decryption
    encstr = hex_to_bytes("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736")

    assert_equal("Cooking MC's like a pound of bacon",
                 find_decryption(encstr))
  end
end
