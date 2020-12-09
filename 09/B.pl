#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use List::Util qw/sum max min/;

open(FH, "<", "input.txt") or die $!;
chomp(my @lines = <FH>);
close FH;

for my $i (25 .. $#lines) {
    my $found = 0;
    SEARCH: {
        for my $a ($i - 25 .. $i) {
            for my $b ($a .. $i) {
                if ($lines[$a] + $lines[$b] == $lines[$i]) {
                    $found = 1;
                    last SEARCH;
                }
            }
        }
    }

    if (!$found) {
        for my $a (0 .. $#lines - 1) {
            for my $b (1 .. $#lines - $a) {
                my $sum = sum(@lines[$a .. $a+$b]);
                if ($sum == $lines[$i]) {
                    print min(@lines[$a .. $a+$b]) + max(@lines[$a .. $a+$b]), "\n";
                }
            }
        }
        last;
    }
}
