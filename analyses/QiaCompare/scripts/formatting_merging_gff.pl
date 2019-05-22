#!/usr/bin/perl

use warnings;
use strict;

my $input = shift(@ARGV);

open(my $in, "<", $input);

my @curr_data = ();
my @prev_data = ();

while (<$in>) {
    chomp;

    my $line = $_;
    my @curr_data = split(/\t/, $line);

    # Adjust pos by -1
    $curr_data[1] = $curr_data[1];
    $curr_data[2] = $curr_data[2];

    # Check if the prev pos is with in 1
    if ($#prev_data == -1) {
        @prev_data = @curr_data;
        next;
    } elsif (($prev_data[1] + 1) == $curr_data[1]) {
        # Merge and Print
        $prev_data[2] = $curr_data[1];
        $prev_data[4] = $prev_data[4] + $curr_data[4];
        $prev_data[5] = $prev_data[5] + $curr_data[5];
        $prev_data[3] = sprintf("%.4f", 
            ($prev_data[4] / ($prev_data[4] + $prev_data[5])) * 100);
        print join("\t", @prev_data) . "\n";
        @prev_data = ();
    } else {
        # Don't need to merge so just print (adjust end +1)
        $prev_data[2] = $prev_data[2] + 1;
        print join("\t", @prev_data) . "\n";
        @prev_data = @curr_data;
    }
}

# Need to print last line of file if it wasn't merged
if ($#prev_data != -1) {
    print join("\t", @prev_data) . "\n";
}
