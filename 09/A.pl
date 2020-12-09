#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

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
        print $lines[$i], "\n";
        last;
    }
}
