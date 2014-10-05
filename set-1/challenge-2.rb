def fixed_xor(str1, str2)
  (str1.to_i(16) ^ str2.to_i(16)).to_s(16)
end

if __FILE__ == $0
  require_relative '../assertions'

  str1 = "1c0111001f010100061a024b53535009181c"
  str2 = "686974207468652062756c6c277320657965"

  assert(fixed_xor(str1, str2) == "746865206b696420646f6e277420706c6179")
end
