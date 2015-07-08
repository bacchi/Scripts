#!/usr/bin/env perl

use strict;
use warnings;

my $word = shift;
print print_rot13_string($word) . "\n";

sub print_rot13_string {
  $word =~ tr/a-zA-Z/n-za-mN-ZA-M/;
  return $word;
}
