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

    hexcontent = base64_to_hex(b64content)

    contents = hex_to_bytes(hexcontent)

    candidate_keysizes = 2.upto(40).map { |keysize|
      chunk_count = 10
      chunk_combinations = contents.chars.take(keysize * chunk_count).each_slice(keysize).to_a.map(&:join).permutation(2).map { |a| Set.new(a) }.uniq
      sample_count = [20, chunk_combinations.length].min

      hd_total = chunk_combinations.sample(sample_count).reduce(0) do |hd, s|
        hd + hamming_distance(*s.to_a)
      end

      [keysize, hd_total / keysize.to_f]
    }.sort_by(&:last).map(&:first).take(1)

    p candidate_keysizes

    # # p candidate_keysizes

    candidate_keysizes.each do |candidate_keysize|
      first, *rest = contents.chars.each_slice(candidate_keysize).to_a
      puts '============'
      # p first
      # p rest.first
      # p first.zip(rest.first).map(&:join)
      #
      p candidate_key = first.zip(*rest).map(&:join).map { |s| find_cipher_key(s) }.join

      p decrypt(contents, candidate_key)
    end
  end
end
