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
can_ok( $mcpan, 'module'        );

# missing input
like(
    exception { $mcpan->module },
    qr/^Please provide a module name/,
    'Missing any information',
);

my $result = $mcpan->module('Moose');
ok( $result, 'Got result' );

