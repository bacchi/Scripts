#!/usr/bin/env perl

# to run this script, you have to install these modules according to the following procedure
# cpanm Furl.pm
# cpanm JSON.pm
# cpanm Cache::LRU
# cpanm Class::Load
# cpanm IO::Socket::SSL
# git clone git://github.com/Songmu/p5-Text-Markdown-GitHubAPI.git Text-Markdown-GitHubAPI
# cd Text-Markdown-GitHubAPI
# perl Makefile.PL
# make
# make install

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
