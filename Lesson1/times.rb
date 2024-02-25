def times(int)
  counter = 0
  while counter < int
    yield(counter)
    counter += 1
  end
  int
end

times(3) { |num| puts num }