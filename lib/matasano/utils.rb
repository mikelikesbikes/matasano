module Matasano
  module Utils
    def hex_to_bytes(hexstr)
      [hexstr].pack("H*")
    end

    def bytes_to_hex(bytes)
      bytes.unpack("H*").first
    end

    def hex_to_base64(str)
      [hex_to_bytes(str)].pack("m0")
    end

    def base64_to_hex(str)
      bytes_to_hex(str.unpack("m0").first)
    end

    def fixed_xor(x, y)
      x.bytes.zip(y.bytes).reduce("") { |s, (a, b)| s << (a.to_i ^ b.to_i).chr }
    end

    def hamming_distance(x, y)
      x.bytes.zip(y.bytes).reduce(0) do |ham, (a, b)|
        val = a ^ b
        dist = 0
        while val > 0
          dist += 1
          val &= val - 1
        end

        ham + dist
      end
    end

    def decrypt(str, key)
      keystr = key.chars.map {|c| "%02x" % c.ord }.cycle.take(str.length / 2).join

      fixed_xor(hex_to_bytes(str),
                hex_to_bytes(keystr))
    end
    alias_method :encrypt, :decrypt


    CHI_SQUARED = -> (v1, v2) {
      (v1 - v2) ** 2 / v1
    }

    ETAOINSHRDLU = ->(str) {
      letters = {" "=>11.504526588730874, "e"=>11.240807440773812, "t"=>8.014230214426677, "a"=>7.227497588474234, "o"=>6.643421623200205, "i"=>6.164656324392252, "n"=>5.9726192267188205, "s"=>5.5991645943769415, "h"=>5.392968079363534, "r"=>5.298276975902442, "d"=>3.763750121682493, "l"=>3.5619784245878283, "u"=>2.4407295639784423}
      # letters = {"a"=>7.227497588474234, "b"=>1.320365666952805, "c"=>2.461968689988407, "d"=>3.763750121682493, "e"=>11.240807440773812, "f"=>1.971698864591722, "g"=>1.7832016212532855, "h"=>5.392968079363534, "i"=>6.164656324392252, "j"=>0.1353994283135249, "k"=>0.6831918866538642, "l"=>3.5619784245878283, "m"=>2.12922238249896, "n"=>5.9726192267188205, "o"=>6.643421623200205, "p"=>1.707094753050912, "q"=>0.08407154045611023, "r"=>5.298276975902442, "s"=>5.5991645943769415, "t"=>8.014230214426677, "u"=>2.4407295639784423, "v"=>0.8654943849060611, "w"=>2.088514057646528, "x"=>0.1327445375622793, "y"=>1.7469181143195958, "z"=>0.06548730519739113, " "=>11.504526588730874}
      # letters = {" "=>11, "e"=>11, "t"=>8, "a"=>7, "o"=>6, "i"=>6, "n"=>5, "s"=>5, "h"=>5, "r"=>5, "d"=>3, "l"=>3}
      hist = str.downcase
                .chars
                .select{|c| letters[c] }
                .each_with_object(Hash.new(0)) { |c, h| h[c] = h[c] + (100.to_f / str.length) }
      letters.reduce(0) { |chi, (c, hc)| chi + CHI_SQUARED.call(hc, hist[c]) }
    }
    LETTER_FREQUENCY = ->(str) {
      letters = {
        "a" => 8167,
        "b" => 1492,
        "c" => 2782,
        "d" => 4253,
        "e" => 12702,
        "f" => 2228,
        "g" => 2015,
        "h" => 6094,
        "i" => 6966,
        "j" => 153,
        "k" => 772,
        "l" => 4025,
        "m" => 2406,
        "n" => 6749,
        "o" => 7507,
        "p" => 1929,
        "q" => 95,
        "r" => 5987,
        "s" => 6327,
        "t" => 9056,
        "u" => 2758,
        "v" => 978,
        "w" => 2360,
        "x" => 150,
        "y" => 1974,
        "z" => 74,
        " " => 13000
      }

      average = letters.values.reduce(:+) / letters.values.length
      str.chars
         .map(&:downcase)
         .reduce(0) { |acc, c| acc + letters.fetch(c, -1 * average) }
    }

    def find_cipher_key(str)
      0.upto(127)
       .map { |k| [k.chr, s = decrypt(str, k.chr), ETAOINSHRDLU.call(s)] }
       .sort_by(&:last)
       .first
       .first
    end

    def find_decryption(str)
      decrypt(str, find_cipher_key(str))
    end

    def find_decryption_in_file(filename)
      File.readlines(filename)
          .map    { |l| find_decryption(l.chomp) }
          .min_by { |s| ETAOINSHRDLU.call(s) }
    end
  end
end

