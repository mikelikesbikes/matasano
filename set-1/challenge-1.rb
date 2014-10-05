def hex_to_base64(str)
  [[str].pack("H*")].pack("m0")
end

if __FILE__ == $0
  require_relative '../assertions'

  str = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
  expected = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

  assert(hex_to_base64(str) == expected)
end
