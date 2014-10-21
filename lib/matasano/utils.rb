require 'set'
require 'openssl'

module Matasano
  module Utils
    extend self

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
        ham + popcount(a ^ b)
      end
    end

    def popcount(x)
      @popcounts ||= Hash.new { |h, k|
        i = k
        m1 = 0x55555555
        m2 = 0x33333333
        m4 = 0x0f0f0f0f
        i -= (i >> 1) & m1
        i = (i & m2) + ((i >> 2) & m2)
        i = (i + (i >> 4)) & m4
        i += i >> 8
        h[k] = (i + (i >> 16)) & 0x3f
      }
      @popcounts[x]
    end

    def find_single_byte_xor_cipher_key(str)
      [*0..127].map(&:chr)
               .max_by { |k| string_score(decrypt(str, k.chr)) }
    end

    def find_repeating_xor_cipher_key(str, keysize = 1)
      first, *rest = str.chars.each_slice(keysize).to_a
      first.zip(*rest)
           .map { |chars| find_single_byte_xor_cipher_key(chars.join) }
           .join
    end

    def find_decryption(str, keysize = 1)
      decrypt(str, find_repeating_xor_cipher_key(str, keysize))
    end

    def decrypt(encrypted, key)
      fixed_xor(encrypted, repeating_key(key, encrypted.length))
    end
    alias_method :encrypt, :decrypt

    def decrypt_aes_ecb(encrypted, key)
      decipher = OpenSSL::Cipher::AES.new(128, :ECB)
      decipher.decrypt
      decipher.key = key
      decipher.update(encrypted) + decipher.final
    end

    def repeating_key(key, length)
      key.chars.cycle.take(length).join
    end

    LETTERS = {"\n"=>0.012048192771084338, " "=>0.16006884681583478, "\""=>0.005737234652897304, "("=>0.0011474469305794606, ")"=>0.0011474469305794606, ","=>0.0068846815834767644, "-"=>0.0034423407917383822, "."=>0.010327022375215147, "/"=>0.0005737234652897303, "0"=>0.0005737234652897303, "1"=>0.0068846815834767644, "2"=>0.002868617326448652, "3"=>0.0005737234652897303, "4"=>0.002868617326448652, "5"=>0.0017211703958691911, "6"=>0.0005737234652897303, "7"=>0.0005737234652897303, "9"=>0.0034423407917383822, ":"=>0.0005737234652897303, "A"=>0.005737234652897304, "B"=>0.004016064257028112, "C"=>0.004016064257028112, "D"=>0.0017211703958691911, "E"=>0.0017211703958691911, "F"=>0.0005737234652897303, "G"=>0.0011474469305794606, "H"=>0.0005737234652897303, "I"=>0.006310958118187034, "J"=>0.0011474469305794606, "L"=>0.0005737234652897303, "M"=>0.0017211703958691911, "N"=>0.002294893861158921, "O"=>0.0011474469305794606, "P"=>0.002294893861158921, "Q"=>0.0017211703958691911, "S"=>0.0005737234652897303, "T"=>0.009753298909925417, "U"=>0.0005737234652897303, "W"=>0.006310958118187034, "a"=>0.06769936890418818, "b"=>0.013195639701663799, "c"=>0.03155479059093517, "d"=>0.03384968445209409, "e"=>0.08835341365461848, "f"=>0.01434308663224326, "g"=>0.01835915088927137, "h"=>0.029259896729776247, "i"=>0.06253585771658061, "k"=>0.006310958118187034, "l"=>0.030407343660355707, "m"=>0.021801491681009755, "n"=>0.04819277108433735, "o"=>0.04991394148020654, "p"=>0.011474469305794608, "r"=>0.05163511187607573, "s"=>0.03327596098680436, "t"=>0.05163511187607573, "u"=>0.022375215146299483, "v"=>0.005737234652897304, "w"=>0.010900745840504877, "x"=>0.002868617326448652, "y"=>0.01434308663224326, "z"=>0.002868617326448652, "|"=>0.0011474469305794606}
    LETTERS.default = 0
    def string_score(str, scores_hash = LETTERS)
      str.chars.reduce(0) do |total, c|
        total += scores_hash[c]
      end
    end

    def find_best_decryption(arr, keysize = 1)
      arr.map    { |s| find_decryption(s, keysize) }
         .max_by { |s| string_score(s) }
    end

    def find_candidate_keysizes(str, n = 1)
      2.upto([str.length, 40].min)
       .sort_by { |keysize| normalized_hamming_distance(*chunks(str, keysize)) }
       .take(n)
    end

    def find_candidate_keysize(str, n = 1)
      find_candidate_keysizes(str, n).first
    end

    def chunks(str, size)
      str.chars
         .each_slice(size)
         .to_a
         .slice(0,10)
         .map(&:join)
    end

    def normalized_hamming_distance(*chunks)
      total = chunks.permutation(2)
                    .map { |a| Set.new(a) }
                    .uniq
                    .map { |s| hamming_distance(*s.to_a) }
                    .reduce(0, :+)
      total / chunks.first.length
    end
  end
end

include Matasano::Utils

