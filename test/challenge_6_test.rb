require 'minitest/autorun'
require_relative '../set-1/xor_cipher'

class Challenge1Test < Minitest::Test
  def test_hamming_distance
    a = "this is a test"
    b = "wokka wokka!!!"

    assert_equal(37, Matasano::Utils.hamming_distance(
                 Matasano::Utils.bytes_to_hex(a),
                 Matasano::Utils.bytes_to_hex(b)))
  end

  def test_break_repeating_xor_key
    contents = Matasano::Utils.hex_to_bytes(Matasano::Utils.base64_to_hex(File.read(File.expand_path('../challenge_6.txt', __FILE__)).chomp.gsub("\n", "")))
    candidate_keysize = 2.upto(40).map { |keysize|
      a = Matasano::Utils.bytes_to_hex(contents.chars.take(keysize).join)
      b = Matasano::Utils.bytes_to_hex(contents.chars.drop(keysize).take(keysize).join)
      [keysize, Matasano::Utils.hamming_distance(a, b) / keysize.to_f]
    }.sort_by(&:last).first.first

    first, *rest = contents.chars.each_slice(candidate_keysize).to_a

    cipher = Matasano::XORCipher.new

    candidate_key = first.zip(*rest).map(&:join).map { |s| Matasano::XORCipher.new.find_cipher_key(s) }.join

    p cipher.decrypt(Matasano::Utils.bytes_to_hex(contents), candidate_key)
  end
end
