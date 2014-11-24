def elias_gamma(x)
  if x < 1
    return nil
  end

	e = Math.log2(x).to_i
  d = x - (1 << e)
  
  return e, d
end

def elias_gamma_encode(x)
  e, d = elias_gamma(x)
  "0:".rjust(e + 2, "1") << d.to_s(2).rjust(e, "0")
end

def elias_delta_encode(x)
  e, d = elias_gamma(x)
  elias_gamma_encode(e + 1) << ":" << d.to_s(2).rjust(e, "0")
end

puts elias_gamma_encode(9)
puts elias_delta_encode(9)

def golomb_rice(x, b)
  if x < 1 or b < 1
    return nil
  end

  p = (x - 1) / b
  q = (x - 1) % b

  return p, q
end

def golomb_rice_encode(x, b)
  p, q = golomb_rice(x, b)
  "0:".rjust(p + 2, "1") << q.to_s(2).rjust(Math.log2(b).to_i, "0")
end

def golomb_encode(l)
  avg = l.reduce(:+).to_f / l.size
  b = (0.69 * avg).to_i
  l.map { |e| golomb_rice_encode(e, b) }
end

def rice_encode(l)
  avg = l.reduce(:+).to_f / l.size
  b = 1 << Math.log2(avg).to_i
  l.map { |e| golomb_rice_encode(e, b) }
end

l = [34, 144, 113, 162]

puts golomb_encode(l)
puts rice_encode(l)

m = l << 123456789
ng = golomb_encode(m)
nr = rice_encode(m)
cg = ng.join.count("01")
cr = nr.join.count("01")
printf "Golomb: %d, Rice: %d, Raw: %d\n", cg, cr, 32 * m.size