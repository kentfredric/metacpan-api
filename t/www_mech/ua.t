#!perl

use strict;
use warnings;

use Test::More;
use MetaCPAN::API;
use t::lib::Functions;

plan skip_all => "WWW::Mechanize required to run this test" unless has_www_mech;
plan tests => 3;
{
    my $mcpan = MetaCPAN::API->new( ua => WWW::Mechanize->new() );
    isa_ok( $mcpan->ua, 'WWW::Mechanize' );
}

{
    my $mcpan = MetaCPAN::API->new(
        ua_args => [ agent => 'MyAgentMon' ],
    );

    my $ua = $mcpan->ua;
    isa_ok( $ua, 'WWW::Mechanize' );
    is( $ua->agent, 'MyAgentMon', 'Correct user agent arguments' );
}

