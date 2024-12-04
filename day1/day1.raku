my $t = now;
# Gets the input from the file using .IO which treats the string as a file path
# and uses the .lines method to get the lines and .map over them
# * is shorthand for &_ arg placeholder
# .words splits the line into words eg. "10  20" -> ["10", "20"]
# ».Int; calls .Int on each of the words
# » is called hyper and is used to apply a function to each of the elements
my @nums = 'day1.input'.IO.lines.map: *.words».Int;
# @nums»[0], @nums»[1] maps over each sub-array and gets the first element and second element
# using these gets each column of the matrix which we then sort
# Z is used to zip the two arrays, pairing the lowest to highest elements together
# then we .map over all the pairs
# $_[0] and $_[1] we get the first and second elements of the pair
# abs gives us the absolute value of the difference which we then sum
say "Part 1: " ~ sum (@nums»[0].sort Z @nums»[1].sort).map: { abs($_[0] - $_[1]) };
# We again take the first and second columns of the matrix
# ∩ gives us the intersection of the arrays
# .keys gives us the unique elements of the intersection which we map over
# we assign the unique element to $key
# we then use the bag function to get the frequency elements in each column
# we multiply the bags of each column together to get the product frequency of multiple occurences
# we then multiply the product frequency by the unique element to get the final result
# .sum is used to sum the result
say "Part 2: " ~ sum (@nums»[0] ∩ @nums»[1]).keys.map: -> $key { $key * (bag(@nums»[0]){$key} * bag(@nums»[1]){$key}) };
say "Time elapsed: {((now - $t) * 1000).fmt('%.3f')} ms";