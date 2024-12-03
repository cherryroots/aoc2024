use v6;

grammar line {
    rule TOP { <left> <right> }
    token left { <number> }
    token right { <number> }
    token number { <[0..9]>+ }
}

my @left-list; my @right-list;
for 'day1_input.txt'.IO.lines -> $line {
    my $result = line.parse($line);
    @left-list.push($result<left>.Int);
    @right-list.push($result<right>.Int);
}

my $left-bag = bag @left-list;
my $right-bag = bag @right-list;


say "Day 1: " ~ sum (@left-list.sort Z @right-list.sort).map: { abs($_[0] - $_[1]) };
say "Day 2: " ~ sum (@left-list (&) @right-list).keys.map: -> $key { $key * ($left-bag{$key} * $right-bag{$key}) };
