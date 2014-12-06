def left_child(i)
  i * 2 + 1
end

def right_child(i)
  i * 2 + 2
end

def max_heapify(a, n, i)
  left = left_child(i)
  right = right_child(i)
  if left < n and a[left] > a[i]
    largest = left
  else
    largest = i
  end
  if right < n and a[right] > a[largest]
    largest = right
  end
  if largest != i
    t = a[i]
    a[i] = a[largest]
    a[largest] = t
    max_heapify(a, n, largest)
  end
end

def heap_sort!(a)
  n = a.length
  (n / 2 - 1).downto(0) do |i|
    max_heapify(a, n, i)
  end

  (n - 1).downto(1) do |i|
    t = a[i]
    a[i] = a[0]
    a[0] = t
    max_heapify(a, i, 0)
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

(0...cases.length).each { |k| printf "Case %d: %s\n", k, heap_sort!(cases[k]).join(" ") }