module Matasano
  module Utils
    def self.hex_to_bytes(hexstr)
      [hexstr].pack("H*")
    end

    def self.bytes_to_hex(bytes)
      bytes.unpack("H*").first
    end

    def self.hex_to_base64(str)
      [hex_to_bytes(str)].pack("m0")
    end

    def self.base64_to_hex(str)
      bytes_to_hex(str.unpack("m0").first)
    end

    def self.fixed_xor(x, y)
      x.bytes.zip(y.bytes).map { |a, b| a.to_i ^ b.to_i }.map(&:chr).join
    end

    def self.hamming_distance(x, y)
      val = x.to_i(16) ^ y.to_i(16)
      dist = 0
      while val > 0
        dist += 1
        val &= val - 1
      end
      dist
    end
  end
end
