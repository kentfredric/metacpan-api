#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Test::Fatal;
use t::lib::Functions;
plan skip_all => "WWW::Mechanize required to run this test" unless has_www_mech;
plan tests => 6;
my $mcpan = mcpan_mech();

isa_ok( $mcpan, 'MetaCPAN::API' );
can_ok( $mcpan, 'release'       );
my $errmsg = qr/^Either provide 'distribution', or 'author' and 'release', or 'search'/;

# missing input
like(
    exception { $mcpan->release },
    $errmsg,
    'Missing any information',
);

# incorrect input
like(
    exception { $mcpan->release( ding => 'dong' ) },
    $errmsg,
    'Incorrect input',
);

my $result = $mcpan->release( distribution => 'Moose' );
ok( $result, 'Got result' );

$result = $mcpan->release(
    author => 'DOY', release => 'Moose-2.0001'
);

ok( $result, 'Got result' );
