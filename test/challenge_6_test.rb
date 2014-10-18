require 'test_helper'

class Challenge6Test < Minitest::Test
  def test_break_repeating_xor_key
    b64content = File.read(File.expand_path('../challenge_6.txt', __FILE__)).chomp.gsub("\n", "")
    contents = hex_to_bytes(base64_to_hex(b64content))

    candidate_keysizes = find_candidate_keysizes(contents)

    candidate_keysizes.each do |keysize|
      puts find_decryption(contents, keysize)
    end
  end
end
