#!/usr/bin/env perl

use strict;
use warnings;
use Text::Markdown::GitHubAPI 'markdown';

my $in = shift;

open my $fh, '<', "$in"
  or die qw{Can't open file: $!};
my $content = do { local $/; <$fh> };
close $fh;

my $html = markdown($content);
open $fh, '>', 'out.html';
print $fh $html;
close $fh;
