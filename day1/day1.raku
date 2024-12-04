my $t = now;
# Get's the input from the file using .IO which treats the string as a file path
# and uses the .lines method to get the lines and maps over them
# * is shorthand for &_ arg placeholder
# .words splits the line into words eg. "10  20" -> ["10", "20"]
# ».Int; calls .Int on each of the words
# » is called hyper and is used to apply a function to each of the elements
my @nums = 'day1.input'.IO.lines.map: *.words».Int;
# we take the sum of the absolute value of the difference between each pair
# @nums»[0] is the first element of each pair
# @nums»[1] is the second element of each pair
# using these gets each column of the matrix
# .sort is used to sort the arrays to get the lowest elements first
# Z is used to zip the two arrays together
# this gives us a zip of the two sorted arrays pairing the lowest elements together
# .map is used to apply a function to each of the elements
# abs is used to get the absolute value of each element
# $_[0] is the first element of the pair
# $_[1] is the second element of the pair
say "Part 1: " ~ sum (@nums»[0].sort Z @nums»[1].sort).map: { abs($_[0] - $_[1]) };
# We again take the first and second columns of the matrix
# ∩ is used to get the intersection of the two arrays
# .keys is used to get the unique elements of the intersection
# .map is used to apply a function to each of the elements
# $key is the unique element of the intersection
# bag is used to get the frequency of each element by counting the number of times it appears in the array
# we multiply the bags of each column together to get the product frequency
# we then multiply by the unique element to get the final result
# .sum is used to sum the result
say "Part 2: " ~ sum (@nums»[0] ∩ @nums»[1]).keys.map: -> $key { $key * (bag(@nums»[0]){$key} * bag(@nums»[1]){$key}) };
say "Time elapsed: {((now - $t) * 1000).fmt('%.3f')} ms";