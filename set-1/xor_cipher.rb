require_relative 'matasano'

module Matasano
  class XORCipher
    include Matasano::Utils

    CONNECTIVES = ->(str) {
      $english_words ||= File.read("/usr/share/dict/connectives").split("\n").freeze
      str.split(/\s+/).select { |w| $english_words.include? w }.length
    }

    ETAOINSHRDLU = ->(str) {
      letters = 'ETAOIN SHRDLU'.chars.reverse
      str.chars
         .map(&:upcase)
         .map { |c, h| letters.index(c) }
         .compact
         .reduce(0, :+)
    }

    def initialize(args = {})
      @scoring_func = ETAOINSHRDLU
    end

    def decrypt(str, key)
      keystr = ("%02x" % key) * (str.length / 2)
      Matasano::Utils.fixed_xor(Matasano::Utils.hex_to_bytes(str),
                                Matasano::Utils.hex_to_bytes(keystr))
    end

    alias_method :encrypt, :decrypt

    def find_cipher_key(str)
      0.upto(255)
       .map    { |k| [k, s = decrypt(str, k), @scoring_func.call(s)] }
       .sort_by(&:last)
       .last
       .first
    end

    def find_decryption(str)
      decrypt(str, find_cipher_key(str))
    end

    def find_decryption_in_file(filename)
      File.readlines(filename)
          .map { |line| find_decryption(line.chomp) }
          .max_by { |s| @scoring_func.call(s) }
    end
  end
end

