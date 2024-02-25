def map(arr)
  counter = 0
  new_arr = []
  while counter < arr.size
    new_arr << yield(arr[counter]) if block_given?
    counter += 1
  end
  new_arr
end

# p map([1,2,3]) { |el| el + 1 }