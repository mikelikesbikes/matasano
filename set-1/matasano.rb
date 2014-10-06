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

    def self.fixed_xor(x, y)
      x.bytes.zip(y.bytes).map { |a, b| a ^ b }.map(&:chr).join
    end
  end
end
