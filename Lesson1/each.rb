def each(arr)
  counter = 0
  while counter < arr.size
    yield(arr[counter])
    counter += 1
  end
  arr
end

each([1, 2, 3]) { |el| puts el + 1 }