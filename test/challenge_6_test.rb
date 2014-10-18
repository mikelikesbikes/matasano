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

    candidate_keysizes = 2.upto(40).sort_by { |keysize|
      chunk_count = 10
      chunk_combinations = contents.chars.each_slice(keysize).to_a.slice(0,10).map(&:join).permutation(2).map { |a| Set.new(a) }.uniq

      hd_total = chunk_combinations.reduce(0) do |hd, s|
        hd + hamming_distance(*s.to_a)
      end

      hd_total / keysize.to_f
    }.take(1)

    candidate_keysizes.each do |candidate_keysize|
      first, *rest = contents.chars.each_slice(candidate_keysize).to_a
      candidate_key = first.zip(*rest).map(&:join).map { |s| find_cipher_key(s) }.join

      decrypt(contents, candidate_key)
    end
  end
end
