def decrypt(encstr)
  decryptions(encstr).max_by { |s| score(s) }
end

def decryptions(encstr)
  (0..255).to_a.map { |k| [encstr].pack('H*').bytes.map { |b| (b ^ k).chr }.join }
end

ENGLISH_KEYWORDS=['the', 'be', 'to', 'of', 'and', 'a', 'in', 'that', 'have', 'I', 'it', 'for', 'not', 'on', 'with', 'he', 'as', 'you', 'do', 'at', 'this', 'but', 'his', 'by', 'from', 'they', 'we', 'say', 'her', 'she', 'or', 'an', 'will', 'my', 'one', 'all', 'would', 'there', 'their', 'what', 'so', 'up', 'out', 'if', 'about', 'who', 'get', 'which', 'go', 'me', 'when', 'make', 'can', 'like', 'time', 'no', 'just', 'him', 'know', 'take', 'people', 'into', 'year', 'your', 'good', 'some', 'could', 'them', 'see', 'other', 'than', 'then', 'now', 'look', 'only', 'come', 'its', 'over', 'think', 'also', 'back', 'after', 'use', 'two', 'how', 'our', 'work', 'first', 'well', 'way', 'even', 'new', 'want', 'because', 'any', 'these', 'give', 'day', 'most', 'us']
def score(str)
  str.split(/\s+/).select { |w| ENGLISH_KEYWORDS.include? w }.length
end

if __FILE__ == $0
  require_relative '../assertions'

  encstr = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

  assert(decrypt(encstr) == "Cooking MC's like a pound of bacon")
end