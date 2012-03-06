#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Test::Fatal;
use t::lib::Functions;
plan skip_all => "WWW::Mechanize required to run this test" unless has_www_mech;
plan tests => 5;
my $mcpan = mcpan_mech();

isa_ok( $mcpan, 'MetaCPAN::API' );
can_ok( $mcpan, 'source'        );
my $errmsg = qr/^Provide 'author' and 'release' and 'path'/;

# missing input
like(
    exception { $mcpan->source },
    $errmsg,
    'Missing any information',
);

# incorrect input
like(
    exception { $mcpan->source( ding => 'dong' ) },
    $errmsg,
    'Incorrect input',
);

my $result = $mcpan->source(
    author => 'DOY', release => 'Moose-2.0201', path => 'lib/Moose.pm',
);
ok( $result, 'Got result' );

