require 'test_helper'

class UtilsTest < Minitest::Test
  def test_hex_to_bytes
    assert_equal("string", hex_to_bytes("737472696e67"))
  end

  def test_bytes_to_hex
    assert_equal("737472696e67", bytes_to_hex("string"))
  end

  def test_hex_to_base64
    str = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
    expected = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

    assert_equal(expected, hex_to_base64(str))
  end

  def test_fixed_xor
    assert_equal("OLMJ", fixed_xor("abcd", "...."))
  end

  def test_hamming_distance
    assert_equal(1, hamming_distance(1.chr, 3.chr))
    assert_equal(37, hamming_distance("this is a test", "wokka wokka!!!"))
  end

  def test_popcount
    assert_equal(1, popcount(1))
    assert_equal(1, popcount(4))
    assert_equal(8, popcount(255))
  end

  def test_find_single_byte_xor_cipher_key
    assert_equal("X", find_single_byte_xor_cipher_key(",01+x1+x9x+,*16?vx6=9,v"))
    assert_equal("x", find_single_byte_xor_cipher_key("\f\u0010\u0011\vX\u0011\vX\u0019X\v\f\n\u0011\u0016\u001FVX\u0016\u001D\u0019\fV"))
  end

  def test_find_single_byte_xor_cipher_key
    assert_equal("XXX", find_repeating_xor_cipher_key(",01+x1+x9x+,*16?vx6=9,v", 3))
    assert_equal("xx", find_repeating_xor_cipher_key("\f\u0010\u0011\vX\u0011\vX\u0019X\v\f\n\u0011\u0016\u001FVX\u0016\u001D\u0019\fV", 2))

    str = "\u0017\a\u0006\u001FC\u0006\u001CL\u0002O\u001C\u0018\u0011\u0006\u0001\vMO\u0001\t\u0002\eAL\u000E\u0016O\e\f\u001D\vBMAO\u0004\f\u0018O\b\f\n\u001CL\n\eO\t\u0015\n\u0001L\u0014\u0000\u001D\a\\NO\u0005D\u0002O\u0005\r\f\u001D\t\a\u0006\r\u0000\u001AO\u001C\u0019\u0011\u001F\u001D\u0005\u0010\n\vL\u0001\u0016O\u0018\v\u0006\u001CB"
    assert_equal("cool", find_repeating_xor_cipher_key(str, 4))
  end

  def test_find_decryption
    assert_equal("this is a string. neat.", find_decryption(",01+x1+x9x+,*16?vx6=9,v"))

    str = "\u0017\a\u0006\u001FC\u0006\u001CL\u0002O\u001C\u0018\u0011\u0006\u0001\vMO\u0001\t\u0002\eAL\u000E\u0016O\e\f\u001D\vBMAO\u0004\f\u0018O\b\f\n\u001CL\n\eO\t\u0015\n\u0001L\u0014\u0000\u001D\a\\NO\u0005D\u0002O\u0005\r\f\u001D\t\a\u0006\r\u0000\u001AO\u001C\u0019\u0011\u001F\u001D\u0005\u0010\n\vL\u0001\u0016O\u0018\v\u0006\u001CB"
    expected = "this is a string. neat. my word... how does it even work?! i'm incredibly surprised by this."
    assert_equal(expected, find_decryption(str, 4))
  end

  def test_encrypt_decrypt
    assert_equal("string", decrypt(encrypt("string", "x"), "x"))
    str = "The bird flies at midnight"
    key = "this is a key"
    assert_equal(str, decrypt(encrypt(str, key), key))
  end

  def test_repeating_key
    assert_equal("xxx", repeating_key("x", 3))
    assert_equal("xxx", repeating_key("xxxxxxx", 3))
    assert_equal("ice", repeating_key("icecube", 3))
    assert_equal("icecubeice", repeating_key("icecube", 10))
    assert_equal("cool"*10, repeating_key("cool",40))
  end

  def test_string_score
    assert(string_score("abcdef") > 0)
    assert_equal(1000, string_score("abcdefghij", Hash.new(100)))
    assert(string_score("this is a string. neat.") > string_score("THIS\u0000IS\u0000A\u0000STRING\u000E\u0000NEAT\u000E"))
  end

  def test_find_candidate_keysizes
    b64content = File.read(File.expand_path('../challenge_6.txt', __FILE__)).chomp.gsub("\n", "")
    contents = hex_to_bytes(base64_to_hex(b64content))

    assert_equal([29], find_candidate_keysizes(contents))
  end

  def test_normalized_hamming_distance
    assert_equal(normalized_hamming_distance("abc", "def"),
                 normalized_hamming_distance("abc"*10, "def"*10))
  end
end

