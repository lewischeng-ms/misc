def compute_word_vector(doc)
  hash = Hash.new(0)

  word = ''
  doc.downcase.each_char do |c|
    if c >= 'a' and c <= 'z'
      word << c
    else
      hash[word] += 1 if not word.empty?
      word = ''
    end
  end

  return hash
end

def compute_document_distance(doc1, doc2)
  dict1 = compute_word_vector(doc1)
  dict2 = compute_word_vector(doc2)

  dict1.each_key.inject(0) { |p, w| p += dict1[w] * dict2[w] }
end

puts compute_document_distance(
  'The fox is in the hat',
  'The fox is outside')