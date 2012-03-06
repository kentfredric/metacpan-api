#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Test::Fatal;
use t::lib::Functions;

plan skip_all => "WWW::Mechanize required to run this test" unless has_www_mech;

plan tests => 4;

my $mcpan = mcpan_mech();

isa_ok( $mcpan, 'MetaCPAN::API' );
can_ok( $mcpan, 'author'        );

# missing input
like(
    exception { $mcpan->author },
    qr/^Please provide an author PAUSEID/,
    'Missing any information',
);

my $result = $mcpan->author('DOY');
ok( $result, 'Got result' );

