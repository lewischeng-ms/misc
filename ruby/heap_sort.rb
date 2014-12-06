def left_child(i)
  i * 2 + 1
end

def right_child(i)
  i * 2 + 2
end

def heap_sort(a)
  (a.length / 2 - 1).downto(0) do |i|
    max_heapify(a, i)
  end
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

(0...cases.length).each { |k| printf "Case %d: %s\n", k, heap_sort(cases[k]).join(" ") }