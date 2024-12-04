my $t = now;
my @nums = 'day1_input.txt'.IO.lines.map: *.words».Int;
say "Part 1: " ~ sum (@nums»[0].sort Z @nums»[1].sort).map: { abs($_[0] - $_[1]) };
say "Part 2: " ~ sum (@nums»[0] (&) @nums»[1]).keys.map: -> $key { $key * (bag(@nums»[0]){$key} * bag(@nums»[1]){$key}) };
say "Time elapsed: {((now - $t) * 1000).fmt('%.3f')} ms";