require 'test_helper'

class Challenge6Test < Minitest::Test
  def test_break_repeating_xor_key
    filename = File.expand_path('../challenge_6.txt', __FILE__)
    contents = hex_to_bytes(base64_to_hex(File.read(filename).chomp.gsub("\n", "")))

    decrypted_first_line = find_decryption(contents, find_candidate_keysize(contents)).split("\n").first
    # look at that dumb space character on the end... that's so dumb.
    expected = "I'm back and I'm ringin' the bell "

    assert_equal(expected, decrypted_first_line)
  end
end
