require 'test_helper'

class Challenge7Test < Minitest::Test
  def test_decrypt_aes_ecb
    filename = File.expand_path('../challenge-7.txt', __FILE__)
    contents = hex_to_bytes(base64_to_hex(File.read(filename).chomp.gsub("\n", "")))

    decrypted_first_line = decrypt_aes_ecb(contents, "YELLOW SUBMARINE").split("\n").first
    # look at that dumb space character on the end... that's so dumb.
    expected = "I'm back and I'm ringin' the bell "

    assert_equal(expected, decrypted_first_line)
  end
end
