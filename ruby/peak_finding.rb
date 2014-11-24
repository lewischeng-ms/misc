require 'matrix'

def peak_finding_helper(a, u, v)
  j = (u + v) / 2

  i = (0...a.row_count).inject(nil) { |i, k| (i.nil? or a[i, j] < a[k, j]) ? k : i }

  if j > u and a[i, j - 1] > a[i, j]
    return peak_finding_helper(a, u, j - 1)
  elsif j < v and a[i, j + 1] > a[i, j]
    return peak_finding_helper(a, j + 1, v)
  else
    return i, j
  end
end

def peak_finding(a)
  if a.row_count.zero? or a.column_count.zero?
    return nil
  end

  peak_finding_helper(a, 0, a.column_count - 1)
end

a = Matrix[
  [1, 2, 3],
  [3, 0, 4],
  [4, 3, 6]
]

i, j = peak_finding(a)
printf "The peak is at (#{i}, #{j})."