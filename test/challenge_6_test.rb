require_relative 'matasano_test'
require 'byebug'
require 'set'

class Challenge6Test < MatasanoTest
  def test_hamming_distance
    a = "this is a test"
    b = "wokka wokka!!!"

    assert_equal(37,
                 hamming_distance(a, b))
  end

  def test_break_repeating_xor_key
    b64content = File.read(File.expand_path('../challenge_6.txt', __FILE__)).chomp.gsub("\n", "")
    contents = hex_to_bytes(base64_to_hex(b64content))

    candidate_keysizes = find_candidate_keysizes(contents)

    candidate_keysizes.each do |keysize|
      puts find_decryption(contents, keysize)
    end
  end
end
