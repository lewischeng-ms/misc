def insert_in_order(a, j, t)
  while j >= 0 and a[j] > t
    a[j + 1] = a[j]
    j -= 1
  end
  
  a[j + 1] = t
end

# binary search
def binary_search_insertion_place(a, i, j, t)
  if i == j
    return i + (a[i] < t ? 1 : 0)
  end
  
  k = (i + j) / 2
  
  if a[k] == t
    return k
  elsif a[k] < t
    return binary_search_insertion_place(a, k + 1, j, t)
  elsif i == k
    return i
  else
    return binary_search_insertion_place(a, i, k - 1, t)
  end
end

def insertion_sort(a)
  for i in 1...a.length
    # insert_in_order(a, i - 1, a[i])
    k = binary_search_insertion_place(a, 0, i - 1, a[i])
    t = a.delete_at(i)
    a.insert(k, t)
  end
  
  return a
end

cases = [
  [ ],
  [ 1 ],
  [ 1, 2 ],
  [ 2, 1 ],
  [ 1, 2, 3, 4, 5 ],
  [ 5, 4, 3, 2, 1 ],
  [ 5, 3, 2, 4, 1 ],
  [ 1, 5, 2, 4, 6, 3 ],
  [ 1, 2, 3, 4, 5, 6 ],
  [ 6, 5, 4, 3, 2, 1 ]
]

(0...cases.length).each { |k| printf "Case %d: %s\n", k, insertion_sort(cases[k]).join(" ") }