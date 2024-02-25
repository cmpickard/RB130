def select(arr)
  new_arr = []
  counter = 0

  while counter < arr.size
    new_arr << arr[counter] if yield(arr[counter])
    counter += 1
  end

  new_arr
end

arr = [1, 2, 3, 4, 5]
p select(arr) { |el| el.odd? }
p select(arr) { |el| puts el }
p select(arr) { |el| el*2 }